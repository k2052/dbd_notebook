require 'nokogiri'
class Default < Post    
  include MongoMapper::Document     
  include CodeParser

  # Keys      
  key :body,  String      
  key :intro, String

  # Key Settings
  slug_key :title, :unique => true  
  before_save   :parse_codeblocks
  before_update :parse_codeblocks  
  
  # Markdown Parser.
  include MongoMapperExt::Markdown     
  markdown :body, :intro, :parser => 'kramdown' 
  
  before_save   :gen_intro
  before_update :gen_intro
  
  def gen_intro
    if intro.blank?
      self.intro = self.body_src.truncate(120)      
      self.intro = Kramdown::Document.new(self.intro).to_html
    end
  end  
    
end