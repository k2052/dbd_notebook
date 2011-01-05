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
    @note = Note.new.from_json(params[:note])
    @note.save
  end  
  
  post :post_create, :map => '/api/post/create' do 
    @post = Post.new.from_json(params[:post])
    @post.save
  end   
  
  post :commentary_create, :map => '/api/commentaries/post' do 
    @commentary = Post.new.from_json(params[:commentary])
    @commentary.save
  end
  
  post :thing_create, :map => '/api/things/create' do   
    @thing = Thing.new.from_json(params[:thing])
    @thing.save
  end 
  
  # I use this to import items from The Hit List but its just a nested JSON structure
  # The strucuture should look like the following {'taskname': { "title": "bob", 'another_task_property' : 'task_attribute', 'tasks' : [] } }
  # I just mixed single quotes and doibles qoutes in a JSON obj oops, don't do that.
  # TODO Proper HTTP Error Codes 
  post :hit_list, :map => '/api/things/hit-list-import' do    
    Thing.hit_list_import(params[:thing])    
    "true"
  end  
        
end