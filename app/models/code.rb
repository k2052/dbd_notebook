class Code < Post
  include MongoMapper::Document

  # Keys
  key :raw,       String
  key :processed, String  
  key :type,      String
                           
  # Key Settings
  slug_key :title, :unique => true
  
  # Associations
  one :commentary 
  
  # Callbacks
  before_save   :generate_code
  before_update :update_code
  
  private      
    def generate_code()         
      return if self.raw.blank? 
      if self.processed.blank? 
        self.processed = CodeRay.scan(self.raw, self.type.downcase.to_sym).html(:wrap => :div, :line_numbers => :inline, :css => :class)  
      else
        return
      end
    end  
     
    def update_code()         
      return if self.raw.blank? 
      self.processed = CodeRay.scan(self.raw, self.type.downcase.to_sym).html(:wrap => :div, :line_numbers => :inline, :css => :class)     
    end   
end