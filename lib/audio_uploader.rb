# encoding: utf-8
require 'mongo_mapper'

module CarrierWave
  module MongoMapper
    include CarrierWave::Mount
    ##
    # See +CarrierWave::Mount#mount_uploader+ for documentation
    #
    def mount_uploader(column, uploader, options={}, &block)
      # We need to set the mount_on column (or key in MongoMapper's case)
      # since MongoMapper will attempt to set the filename on 
      # the uploader instead of the file on a Document's initialization.
      options[:mount_on] ||= "#{column}_filename"
      key options[:mount_on]
      
      super
      alias_method :read_uploader, :[]
      alias_method :write_uploader, :[]=
      after_save "store_#{column}!".to_sym
      before_save "write_#{column}_identifier".to_sym
      after_destroy "remove_#{column}!".to_sym
    end
  end # MongoMapper
end # CarrierWave

MongoMapper::Plugins::Document::ClassMethods.send(:include, CarrierWave::MongoMapper)

                                                 
class AudioUploader < CarrierWave::Uploader::Base            

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
    'audio/uploads'
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
    %w(mp3)
  end

end
