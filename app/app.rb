class DbdNotebook < Padrino::Application    
  
  ##
  # Intializers
  #
  
  # Padrino Core
  register Padrino::Helpers   
  register NavvyInitializer
  register DefenderInitializer       
  
  # Resources. JS, CSS handling ext
  register CompassInitializer 
  require 'sinatra/minify'   
  register Sinatra::Minify    

  ##
  # App Settings 
  #
  
  # Sinatra Minify
  if Padrino.env == :production  
    set :public_url, "http://assets0-notebook.designbreakdown.com/css"       
    set :css_url, 'http://assets0-notebook.designbreakdown.com/css'
    set :js_url, "http://assets0-notebook.designbreakdown.com/js" # => http://site.com/js  
  else   
    set :css_url, '/css' # => http://site.com/js 
    set :js_url, '/js' # => http://site.com/js                
  end
  set :js_path, '../public/js' # => ~/myproject/public/js
  set :css_path, '../public/css'
  set :minify_config, '../config/assets.yml'
  
end