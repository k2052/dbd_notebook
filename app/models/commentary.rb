class Commentary  
  include MongoMapper::EmbeddedDocument

  # Keys
  key :body,     String
  key :body_src, String 
   
  # Callbacks
  before_save   :generate_rendered
  before_update :update_rendered
  
  # Associations
  belongs_to :audio
  belongs_to :code
      
  private              
  
    def generate_rendered()         
      return if body_src.blank? 
      if self.body.blank? 
        krammed = Kramdown::Document.new(self.body_src).to_html   
        self.body = Sanitize.clean(krammed, Sanitize::Config::BASIC)
      else
        return
      end
    end   
    
    def update_rendered()         
      return if body_src.blank? 
      krammed = Kramdown::Document.new(self.body_src).to_html   
      self.body = Sanitize.clean(krammed, Sanitize::Config::BASIC)   
    end
  
end