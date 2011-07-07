DbdNotebook.controllers :comments do
  
  # Trys to prevent spam with a CSS hidden field that should never be filled and by requiring submision via ajax.
  post :create, :map => '/:slug/comments/create' do
    if request.xhr? && params[:username].blank?    
      slug = params[:slug].match(/^([A-Za-z0-9-]+)/i).to_s    
      @post = Post.find_by_slug(:slug => slug)
      @comment = Comment.new(params[:comment])        
      @comment.spam = true
      @comment.checked = false
      @comment.post_id = @post.id    
      if @comment.save   
        if @post.save     
          error_hash = {:errorCode => :success, :message => "Your comment has been submitted. It will undergo an examination for spam and then appear shortly thereafter."}
          ret = error_hash.to_json
        else   
          error_hash = {:errorCode => :failure, :message => @post.errors.full_messages}
          ret = error_hash.to_json
        end 
      else       
        error_hash = {:errorCode => :failure, :message => @comment.errors.full_messages}
        ret = error_hash.to_json
      end 
      request_hash = gen_request_hash
      Resque.enqueue(CommentSpam, @comment.id, request_hash)  
      ret
    else
      "This form only accpts a valid submission submitted via ajax. Please enable javascript in your browser and try again."
    end
  end 
end