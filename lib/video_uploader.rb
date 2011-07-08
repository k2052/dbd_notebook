class VideoUploader < CarrierWave::Uploader::Base            

  ##
  # Storage type
  #   
  storage :file                   
     
  configure do |config|         
    config.s3_cnamed = true
    config.s3_access_key_id     = ENV['S3_ACCESS_KEY']
    config.s3_secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
    config.s3_bucket =  ENV['S3_BUCKET'] 
  end
  
  ## Manually set root
  def root; File.join(Padrino.root,"public/"); end

  ##
  # Directory where uploaded files will be stored (default is /public/uploads)
  # 
  def store_dir
    'videos/uploads'
  end

  ##
  # Directory where uploaded temp files will be stored (default is [root]/tmp)
  # 
  def cache_dir
    Padrino.root("tmp")
  end
  
  # White list of extensions which are allowed to be uploaded:
  # 
  def extension_white_list
    %w(flv avi mov)
  end

end
