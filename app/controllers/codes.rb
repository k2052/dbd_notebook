DbdNotebook.controllers :codes do  
  
  # Returns the raw (unprocessed by coderay) code for a Code Post.
  get :raw, :map => '/codes/:slug/raw' do   
    content_type :text
    @code = Post.find_by_slug(:slug => params[:slug])
    @code.raw        
  end  
  
end