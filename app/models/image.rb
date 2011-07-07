class Image
  include MongoMapper::EmbeddedDocument
      
  # Keys
  key :caption, String
  key :title,   String 
  
  # Key Settings 
  mount_uploader :image, ImageUploader  
  
  # Associations
  belongs_to :gallery   
   
  ## 
  # Collection Methods
  #
  
  def self.delete(imageID, parentID)        
    @parent = Gallery.find(parentID)    
    imageID = BSON::ObjectId.from_string(imageID)    
    @parent.images.delete_if {|image| image.id == imageID} 
    if @parent.save 
      return true
    else 
      return false
    end
  end
end