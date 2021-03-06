require 'kramdown' 
require 'sanitize'
class Comment
  include MongoMapper::Document       
  include MongoMapperExt::Markdown  
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
  key :comment,       String     
  key :spam,          Boolean, :default => true
  key :checked,       Boolean   
  key :gravatar_hash, String
  timestamps!   
  
  # Key Settings
  markdown :comment, :parser => 'kramdown'         
  
  # Validations
  validates_presence_of     :email 
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  
  validates_format_of       :url,      :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_nil => true
  
  # Callbacks 
  before_save   :sanitize, :set_path, :gen_gravatar_hash
  before_update :sanitize
  
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
    flagged = Comment.all(:spam => true)
    return flagged
  end 
  
  # Return an array of comments, threaded.
  def self.threaded_with_field(post, field_name='created_at')
    comments = Comment.all(:conditions => {:post_id => post.id, :spam => false, :checked => true}, :order => "path asc, #{field_name} asc")
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
  
  def self.spam_update(commentID, spam)          
    commentID = BSON::ObjectId.from_string(commentID) 
    Comment.collection.update({'_id' => commentID}, {'$set' => {'spam' => spam, 'checked' => true} })
  end
  
  def self.mark_as_spam(commentID) 
    commentID = BSON::ObjectId.from_string(commentID)  
    Comment.collection.update({'_id' => commentID}, {'$set' => {'spam' => true, 'checked' => true} })
  end 
  
  def self.unmark_as_spam(commentID) 
    commentID = BSON::ObjectId.from_string(commentID)  
    Comment.collection.update({'_id' => commentID}, {'$set' => {'spam' => false, 'checked' => true} })
  end   
  
  # Determine spaminess using defension  
  def spam?   
    spam = Akismet.spam?(akismet_attributes, request)
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
    
    def sanitize() 
      self.comment = Sanitize.clean(self.comment, Sanitize::Config::BASIC)
    end      
    
    def gen_gravatar_hash()    
      self.gravatar_hash   = Digest::MD5.hexdigest(self.email.downcase)
    end    
end