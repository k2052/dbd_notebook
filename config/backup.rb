# Automatic backups using the Backup gem
# See: https://github.com/meskyanichi/backup/
heroku_env = File.join(File.dirname(__FILE__), 'heroku_env.rb')
load(heroku_env) if File.exists?(heroku_env)        

backup 'mongodb-backup-s3' do

  adapter :mongo do
    database "#{ENV['app_name']}_production" 
  end

  storage :s3 do
    access_key_id     ENV['S3_ACCESS_KEY']
    secret_access_key ENV['S3_SECRET_ACCESS_KEY']
    bucket            'dbd-backups/dbd-notebook/mongodb'
  end

  keep_backups 25
  encrypt_with_password false
  notify false
end