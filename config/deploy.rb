 # Vlad aint it lovely?
# We need the following for this to work.
# Git installed on remote server, Nginx installed on remote server, Sudo perimissions on remote server
# Thin installed on remote server, and of course Vlad installed locally and remotely  
# This will create a git repository on the remote server in /home/#{deploy_user}/repos/#{app_name}.git 
# and then deploy to /home/:deploy_user/:app_domain_name        
# it will then setup a nignx vhost, configure nginx and then launch nginx using a file in config/nginx-template.erb

heroku_env = File.join(File.dirname(__FILE__), 'heroku_env.rb')
load(heroku_env) if File.exists?(heroku_env)

set :deploy_user,      ENV['DEPLOY_USER']     
set :app_name,         ENV['APP_NAME']        
set :ssh_user,         ENV['SSH_USER']        
set :domain,           ENV['DEPLOY_DOMAIN']          
set :app_domain_name,  ENV['APP_DOMAIN'] 
set :repository,       ENV['REPOSITORY']      
set :deploy_to,        ENV['DEPLOY_TO']       
set :nginx_site_path,  ENV['NGINX_SITE_PATH'] 
set :deploy_via,       ENV['deploy_via']      
set :sudo_password,    ENV['SUDO_PASSWORD']   
set :num_thin_servers, ENV['NUM_THIN_SERVERS']
set :thin_port,        ENV['THIN_PORT']    
set :now,              Time.now 

namespace :vlad do   
       
  remote_task :server_prep do  
    run "mkdir /home/#{deploy_user}/repos"
  end          
  
  remote_task :setup_git do              
    run "mkdir /home/#{deploy_user}/repos/#{app_name}.git"   
    run "mkdir /home/#{deploy_user}/#{app_domain_name}"  
    run "mkdir /home/#{deploy_user}/#{app_domain_name}/#{app_name}"
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && git init --bare"
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && git config core.worktree /home/#{deploy_user}/#{app_domain_name}/#{app_name}"
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && git config core.bare false"
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && git config receive.denycurrentbranch ignore"        
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && echo '#!/bin/sh' > hooks/post-receive"    
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && echo 'git checkout -f' >> hooks/post-receive"
    run "cd /home/#{deploy_user}/repos/#{app_name}.git && sudo chmod +x hooks/post-receive" 
  end      
  
  task :setup_git_local do   
    %x{git remote add web ssh://#{domain}/home/#{deploy_user}/repos/#{app_name}.git}
  end     
   
  task :push_git do 
    %x{git push web master}
  end   
        
  remote_task :bundle_install do    
    run "cd /home/#{deploy_user}/#{app_domain_name}/#{app_name} && sudo bundle install"
  end     
  
  remote_task :parse_nginx_template do 
    require 'erb'             
    template = File.read('config/nginx-template.erb')  
    buffer = ERB.new(template).result(binding)
    put nginx_site_path, 'vlad.nginx_template' do
      buffer  
    end
  end     
  
  remote_task :setup_nginx_vhost do 
    run "cd /etc/nginx && sudo ln -s /etc/nginx/sites-available/#{app_domain_name} /etc/nginx/sites-enabled/#{app_domain_name}"
  end   
  
  remote_task :restart_nginx do    
    run "sudo /etc/init.d/nginx stop"
    run "sudo /etc/init.d/nginx start"
  end   
  
  task :create_mongodb_dump do
    %x{mongodump -d #{db_name}}
  end           
  
  task :zip_mongodb_dump do      
    %x{cd ~/backups/db && tar cvf backup_#{db_name}_date_#{now.strftime("%Y-%m-%d-%I-%M-%S")}}       
    %x{cd ~/backups/db && gzip backup_#{db_name}_date_#{now.strftime("%Y-%m-%d-%I-%M-%S")}}
  end  
  
  task :local_update_crontab do
    %x{cd ~/rubyprojects/#{app_name} && whenever --update-crontab #{app_name}}
  end    
  
  remote_task :remote_update_crontab do
    run "cd #{deploy_to} && whenever --update-crontab #{app_name}"
  end  
  
  task :minify do
    run %x{cd ~/rubyprojects/#{app_name} && bundle exec padrino rake minify }
  end
end    

task "vlad:predeploy" => %w[  
  vlad:server_prep
]

task "vlad:deployit" => %w[  
  vlad:minify
  vlad:setup_git
  vlad:setup_git_local
  vlad:push_git      
  vlad:bundle_install
  vlad:parse_nginx_template
  vlad:setup_nginx_vhost
  vlad:restart_nginx
  vlad:remote_update_crontab
] 

task "vlad:updateit" => %w[    
  vlad:minify
  vlad:push_git    
  vlad:restart_nginx
]