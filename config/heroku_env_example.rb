# Heroku ENV Vars. Don't push this to heroku, obviously.   
if Padrino.env == :production  
  ENV['DOMAIN'] = 'notebook.designbreakdown.com'  
else
  ENV['DOMAIN'] = 'localhost:3000' 
end
ENV['ASSET_HOST']           = "http://assets%d-notebook.designbreakdown.com"  
ENV['ASSET_HOST_COUNT']     = '4'

# Postmark         
ENV['POSTMARK_KEY'] = 'XXXXXXXXXXXXX'
                   
# Akismet          
ENV['AKISMET_KEY']  = 'XXXXXXXXXXXX'   

# S3
ENV['S3_ACCESS_KEY']            = 'XXXXXXXXX'
ENV['S3_SECRET_ACCESS_KEY']     = 'XXXXXXXXX' 
ENV['S3_BUCKET']                = 'media-notebook.designbreakdown.com'      

# Pass Stuff  
ENV['PASS_SALT_SECRET']         = "ACirclesSharpEdge"           

# VLAD/Deployment Enviroment Variables
ENV['DEPLOY_USER']      = "xxx"
ENV['APP_NAME']         = "dbd_notebook" 
ENV['SSH_USER']         = "xxx" 
ENV['DEPLOY_DOMAIN']    = "XXXXXXXXXXXXXX" 
ENV['APP_DOMAIN']       = "notebook.designbreakdown.com"
ENV['REPOSITORY']       = "ssh://#{ENV['DEPLOY_DOMAIN']}/home/#{ENV['DEPLOY_USER']}/repos/#{ENV['APP_NAME']}.git"
ENV['DEPLOY_TO']        = "/home/#{ENV['DEPLOY_USER']}/#{ENV['APP_DOMAIN']}/#{ENV['APP_NAME']}"     
ENV['NGINX_SITE_PATH']  = "/etc/nginx/sites-available/#{ENV['APP_DOMAIN']}"
ENV['DEPLOY_VIA']       = "git"        

# Authorization
ENV['IP_ACCESS']        = 'XXXXXXXXXXXX'