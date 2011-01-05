class Quote <Post
  include MongoMapper::Document

  # Keys
  key :quote,       String
  key :quote_src,   String
  key :author,      String
  key :author_link, String , :default => '#'       
  
  # Key Settings
  slug_key :title, :unique => true
  
  # Associations
  one :commentary
 
  # Callbacks
  before_save   :generate_rendered
  before_update :update_rendered  
  
  private     
  
    def generate_rendered()         
      return if quote_src.blank? 
      if self.quote.blank? 
        self.quote = Kramdown::Document.new(self.quote_src).to_html                 
      else
        return
      end
    end  
     
    def update_rendered()         
      return if quote_src.blank? 
      self.quote = Kramdown::Document.new(self.quote_src).to_html                 
    end
      
end