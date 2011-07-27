class Commentary  
  include MongoMapper::EmbeddedDocument     
  include MongoMapperExt::Markdown
  
  # Keys
  key :body, String
  
  # Key Settings
  markdown :body, :parser => 'kramdown'
  
  # Associations
  belongs_to :audio
  belongs_to :code
end