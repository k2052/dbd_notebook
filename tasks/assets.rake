connection = Fog::Storage.new(
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV['S3_SECRET_ACCESS_KEY'],
  :aws_access_key_id => ENV['S3_ACCESS_KEY']
)         

namespace :assets do 
       
  task :upload do 
     
    files = Rake::FileList.new(
      "#{PADRINO_ROOT}/public/*",
      "#{PADRINO_ROOT}/public/**/*"
    )
      
    ENV['ASSET_HOST_COUNT'].to_i.times do |i|
      asset_host = ENV['ASSET_HOST'].gsub("%d", "#{i + 1}").gsub('http://', '')
      directory = connection.directories.get(asset_host)    
      prefix = '' 
      files.each do |f|
        next if File.directory?(f)
        key = f.gsub(/public/, prefix).gsub(PADRINO_ROOT, '').gsub(/^[\/]+/, '')
        puts "uploading %s" % key
        attrs = {}  

        file = directory.files.create(   
          :key    => key,
          :body   => File.open(f),
          :public => true  
        )              
      end
    end
  end   
  
  task :create_buckets do     
    
    ENV['ASSET_HOST_COUNT'].to_i.times do |i|
      asset_host = ENV['ASSET_HOST'].gsub("%d", "#{i + 1}").gsub('http://', '')
      puts "creating bucket: #{asset_host}"
      connection.directories.create(
        :key    => asset_host, 
        :public => true   
      )
    end
  end
end