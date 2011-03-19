require 'kramdown' 
require 'sanitize'
class Comment
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Timestamps   

  # Keys  
  key :depth,         Integer, :default => 0
  key :path,          Array    
  key :post_id,       ObjectId 
  key :parent_id,     String           
  
  # Very special key nothing is ever save to it, only used during mapping.
  key :comments,      Array
                     
  key :first_name,    String
  key :last_name,     String
  key :email,         String
  key :url,           String
  key :cmnt_src,      String
  key :comment,       String     
  key :allow,         Boolean
  key :checked,       Boolean   
  key :gravatar_hash, String
  timestamps!  
  
  # Validations
  if validations.empty?      
    validates_presence_of     :email 
    validates_length_of       :email,    :within => 3..100
    validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  
    validates_format_of       :url,      :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_nil => true
  end  
  
  # Callbacks 
  before_save   :generate_rendered, :set_path, :gen_gravatar_hash
  before_update :update_rendered
  
  # Associations        
  belongs_to :post, :class_name => "Post",  :foreign_key => "post_id"    
  many :comments
  
  ##
  # Getter and Setter Methods
  #   
  
  # Called Saving Name
  def name=(t) 
    if t.kind_of?(String)
      t = t.split(",").join(" ").split(" ").uniq
    end
    self[:first_name] = t[0]
    self[:last_name]  = t[1]
  end
     
  # Returns the name
  def name()
    if !self.first_name.blank? && !self.last_name.blank? 
      return "#{self[:first_name]}, #{self[:last_name]}"  
    else
      return self.first_name
    end
  end   
  
  ##
  # Instance Methods.   
  #       
  
  # Is this a root node?
  def root?
    self.depth.zero?
  end        
  
  ##
  # Collection Methods
  # 
  
  # Lists Flagged Comments
  def self.flagged_comments  
    flagged = Comment.all(:allow => false)
    return flagged
  end 
  
  # Return an array of comments, threaded.
  def self.threaded_with_field(post, field_name='created_at')
    comments = Comment.all(:conditions => {:post_id => post.id, :allow => true, :checked => true}, :order => "path asc, #{field_name} asc")
    results, map  = [], {}
    comments.each do |comment|  
      if comment.parent_id.blank?
        results << comment
      else 
        map[comment.parent_id] ||= []
        map[comment.parent_id] << comment      
      end
    end 
    assemble(results, map)        
  end   
  
  # We should use the map when looping through.
  # If the comment has stuff in the map we ouput it into the parent.
  
  # Recursive method to loop over and map the tasks.
  def self.assemble(results, map)
    list = []
    results.each do |result|
      if map[result.id.to_s]    
        result[:comments] += self.assemble(map[result.id.to_s], map) 
        list << result
      else   
        list << result
      end
    end
    list
  end  
  
  ##
  # Spam Methods.
  #      
  
  def self.spam_update(commentID, allow)          
    commentID = BSON::ObjectId.from_string(commentID) 
    Comment.collection.update({'_id' => commentID}, {'$set' => {'allow' => allow, 'checked' => true} })
  end
  
  def self.mark_as_spam(commentID) 
    commentID = BSON::ObjectId.from_string(commentID)  
    Comment.collection.update({'_id' => commentID}, {'$set' => {'allow' => false, 'checked' => true} })
  end 
  
  def self.unmark_as_spam(commentID) 
    commentID = BSON::ObjectId.from_string(commentID)  
    Comment.collection.update({'_id' => commentID}, {'$set' => {'allow' => true, 'checked' => true} })
  end
  
  private       
  
    def set_path      
      if !self.parent_id.blank?    
        parent        = Comment.find(self.parent_id)
        self.post_id  = parent.post_id
        self.depth    = parent.depth + 1
        self.path     = parent.path              
        self.path     << parent.id.to_s   
      end     
    end       
    
    def generate_rendered() 
      return if cmnt_src.blank? 
      if self.comment.blank? 
        krammed = Kramdown::Document.new(self.cmnt_src).to_html   
        self.comment = Sanitize.clean(krammed, Sanitize::Config::BASIC)
      else
        return
      end
    end      
    
    def update_rendered()         
      return if cmnt_src.blank? 
      krammed = Kramdown::Document.new(self.cmnt_src).to_html   
      self.comment = Sanitize.clean(krammed, Sanitize::Config::BASIC)   
    end  
    
    def gen_gravatar_hash()    
      self.gravatar_hash   = Digest::MD5.hexdigest(self.email.downcase)
    end
  
end