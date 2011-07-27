require 'kramdown'
class Gallery < Post
  include MongoMapper::Document
  include MongoMapperExt::Markdown  

  # Keys      
  key :body,  String      
  key :intro, String

  # Key Settings
  slug_key :title, :unique => true
  markdown :body, :intro, :parser => 'kramdown'    
  
  # Associations
  many :images  
end