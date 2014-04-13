## Intro

Source code for http://notebook.designbreakdown.com. 

Uses padrino, mongodb, mongomapper, postmark API, carrierwave, Navvy and Defensio. 
It's a great example of a real world blogging project using padrino and mongodb.   

Has multiple totally unique post types, ajax comments, spam checking and a rudimentary API. 
Comes with my vlad deployment script and my nginx template which I use for deploying to my servers in only two commands.  

The Admin panel is messy but it suits my needs well enough. 
You'll probably want to be familiar with mongodb because there are quite a few little glitches with adding and editing documents. If you mess something up its a quick and easy fix if you know your mongodb commands.         

I'll be expanding this app as I require new features for the notebook so feel free to watch this space for updates.     

## Warnings.

This should not be used in production with untrusted ADMIN users. With the exception of the comments nothing is sanitized. 
You'll need to make modifications to the models and controllers to protect against XSS and injection.        

## Installation/Setup

1. You'll need to first setup and install all the needed gems. 
  There is a Gemfile for bundler which I suggest you use, but if you choose not to you can refer to it for the list of needed gems.

2. After that you'll need to setup the following ENV vars.
  You can either 1. Use your .bashrc file, 2. Use heroku and add the vars using their tool.
  Or 3. Use a heroku_env.rb file and place it in config/. heroku_ev.rb is loaded if it exists. 
  If you choose this method you should probably add the file to your gitignore so it is not checked in with subversion.
  
  ### ENV Vars     

  #### Heroku ENV Vars. Don't push this to heroku, obviously. 
  `                                
    # Defensio for comment spam
    ENV['DEFENSIO_KEY']             = 'XXX'   
    
    # Postmark is used to send out alerts etc.
    ENV['POSTMARK_KEY']             = 'XXX'
  
    # S3 is used for media uploads
    ENV['S3_ACCESS_KEY']            = 'XXX'
    ENV['S3_SECRET_ACCESS_KEY']     = 'XXX'   
      
    # S3 Bucket where media is stored   
    # Images/videos etc will be stored in a subfolder of the bucket.
    # e.g bucketName/images bucketName/videos 
    ENV['S3_BUCKET']                = 'Bucket To Store Media In'
  
    # Used as an extra salt to encrypt passwords. Refer to app/model/account.rb
    ENV['PASS_SALT_SECRET']         = "XXX"  
  ` 

  #### VLAD/Deployment Enviroment Variables
  `
    ENV['deploy_user']      = "ubuntu"
    ENV['app_name']         = "app_name" 
    ENV['ssh_user']         = "ubuntu" 
    ENV['domain']           = "xxx.amazonaws.com" 
    ENV['app_domain_name']  = "domain.domain.com"
    ENV['repository']       = "ssh://#{ENV['domain']}/home/#{ENV['deploy_user']}/repos/#{ENV['app_name']}.git"
    ENV['deploy_to']        = "/home/#{ENV['deploy_user']}/#{ENV['app_domain_name']}/#{ENV['app_name']}"     
    ENV['nginx_site_path']  = "/etc/nginx/sites-available/#{ENV['app_domain_name']}"
    ENV['deploy_via']       = "git"    
    ENV['num_thin_servers'] = '2' 
    ENV['thin_port']        = '3000'  
  `  

3. Check over the models for 
  `
  when :development then self.set_database_name 'dbd_club_development'
  when :production  then self.set_database_name 'dbd_club_production'     
  `    
  I've hardcoded coded some of the DB names (to share data across DBD sites) into my models make sure you change them.       

4. Remove google analytics from app/views/other/home.haml
  Please don't leave in my tracking code.     
  
5. Set Production Asset urls.

  Look for the following lines and make sure you set them you to your own urls
  `
  set :public_url, "http://assets0-notebook.designbreakdown.com/css"       
  set :css_url, 'http://assets0-notebook.designbreakdown.com/css'
  set :js_url, "http://assets0-notebook.designbreakdown.com/js" # => http://site.com/js

## Notes

Supports a variety of different post types from video posts to code posts.  

### Media            

Media is managed entirely on S3 using asset buckets and media bucket. 
The media bucket holds all the images/videos/ any other uploads etc.  
If your not using S3 then you'll to reconfigure
`lib/image_uploader.rb`
`lib/audio_uploader.rb`  
`lib/video_uploader.rb`
and           
`compass_plugin.rb`
  
### Code/Snippet Processing
Includes a snippet processor in the default post type that process any code snippets a creates code posts, then inserts them into the post.

Code processing done using CodeRay. Comes with two completely custom CSS CodeRay theme files.  
1. Based on the RailsCasts TextMate theme.
2. And one based on a Customized Freckle TextMate Theme         

### Comments 

Comes with an advanced Ajax comment system inspired by the comment system in the woothemes unite theme.
Full spam checking and flagging using Defensio.   
Comments can be unlimitedly nested but I highly recommended you  place some sort of obituary limit.   
  
### Tasks

Has a pretty advanced task management system that replicates allot of the functionality found in The Hit List. 
Like nested tasks, notes popup etc. If you feed it some properly formatter JSON it will spit you out a nice task list.

### Deployment                       

The app contains a VLAD deployment script that directly relies on git.   
To use it you'll need to make sure you've VLAD + git installed on both your sever and locally.
To understand how to setup your server paths correctly and to understand my deployment setup refer to config/deploy.rb

### Backup

Backup is done using the backup gem from https://github.com/meskyanichi/backup combined with the whenever gem to easily manage the cron tasks.

It also expects you to have a sqlite db in db/.
You can ignore that need but it will error out when it tries to log the backup.
Make sure you set that up or you'll regret it when your log files fill up your server.   

To configure the backup gem look to backup.rb and schedule.rb   

### API

Has a very rudimentary WIP API. Its a good basic example of Sinatra API building. 
The before filter authorization can easily be replaced or extended with something more advanced like say Oauth.
For now authorization is done using IP address make sure to sure set ENV['IP_ACCESS'] to your authorized IP. 

## License

Copyright (C) 2009-2010 Ken Erickson AKA Bookworm. (http://bookwormproductions.net)

Media License.    
 
You do not receive any rights to use the fonts, images or videos. 
These are for example purposes only and you must replace them.    
You may not use any of the fonts, images, or videos on any site without permission. 

Also please be reasonable with your css usage i.e don't just swap-out graphics.

All Source Code Is Licensed under WTFPL.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 3, August 2010. 
 
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
  0. Do Not Claim Authorship Of Code You Did Not Author.
  1. Do Not Use The Same Name As The Original Project.
  2. Beyond That, You just DO WHAT THE FUCK YOU WANT TO.  
   
## Support

If you found this repo useful please consider supporting me on [Gittip](https://www.gittip.com/k2052) or sending me some
bitcoin `1csGsaDCFLRPPqugYjX93PEzaStuqXVMu`
  
