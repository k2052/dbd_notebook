class Quote <Post
  include MongoMapper::Document
  include MongoMapperExt::Markdown

  # Keys
  key :quote,       String
  key :author,      String
  key :author_link, String , :default => '#'       
  
  # Key Settings
  slug_key :title, :unique => true     
  markdown :quote, :parser => 'kramdown'
  
  # Associations
  one :commentary
 
end