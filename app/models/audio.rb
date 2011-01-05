class Audio < Post
  include MongoMapper::Document

  # Keys
  key :track_num,  String
  key :year,       String
  key :album,      String
  key :song_title, String
  key :artist,     String
  key :length,     Integer   
  key :embed,      String 
  
  # Key Settings 
  mount_uploader :file, AudioUploader     
  slug_key :title, :unique => true
  
  # Associations
  one :commentary

end