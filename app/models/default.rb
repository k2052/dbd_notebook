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
    
end