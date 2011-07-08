# A Very simple API. 
# Speaks JSON and handles imports from the hit list.    
# Protected by IP but could just as easy be done using Oauth.
# I use a variety of local ruby scripts to pull out my data and push it up. 
# Some of these can be found in the github repo here
DbdNotebook.controllers :api do
 
  before do       
    unless @env['REMOTE_ADDR'] == '127.0.0.1' || @env['REMOTE_ADDR'] == ENV['IP_ACCESS'] 
      halt 403, "Not Authorized"
    end   
  end  

  post :note_create, :map => '/api/notes/create' do 
    @note = Note.from_json(params[:post])
    if @note.save    
      'Saved Note Successfully'
    else
      halt 400, @note.errors.full_messages   
    end
  end  
  
  post :post_create, :map => '/api/posts/create' do  
    type = params[:type].to_s        
    
    if !type.empty?() 
      type = type.match(/^([A-Za-z0-9-]+)/i).to_s.downcase.capitalize    
    end              
    
    postclass = Object.const_get(type)
    @post = postclass.from_json(params[:post])        
    
    if @post.save
      'Saved Post Successfully'
    else
      @post.errors.full_messages   
    end
  end
  
  post :default_create, :map => '/api/defaults/create' do 
    @default = Default.from_json(params[:post])
    if @default.save
      'Saved Default Post Successfully'
    else
      halt 400, @default.errors.full_messages   
    end
  end   
  
  post :commentary_create, :map => '/api/commentaries/create' do 
    @commentary = Commentary.from_json(params[:post])
    if @commentary.save
      'Saved Commentary Successfully'
    else
      halt 400, @commentary.errors.full_messages   
    end
  end
  
  post :thing_create, :map => '/api/things/create' do    
    @thing = Thing.from_json(params[:post])
    if @thing.save
      'Saved Thing Successfully'
    else
      halt 400, @thing.errors.full_messages   
    end
  end      
end