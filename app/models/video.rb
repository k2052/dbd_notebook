class Video < Post
  include MongoMapper::Document
  include MongoMapperExt::Markdown  

  # Keys
  key :body,      String
  key :intro,     String
  key :src,       String
  key :src_link,  String
  key :length,    String
  key :embed,     String   
  
  # Key Settings 
  mount_uploader :file, VideoUploader  
  slug_key :title, :unique => true
  markdown :body, :intro, :parser => 'kramdown'    

end