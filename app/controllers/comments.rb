DbdNotebook.controllers :comments do
  
  # Trys to prevent spam with a CSS hidden field that should never be filled and by requiring submision via ajax.
  post :create, :map => '/:slug/comments/create' do
    if request.xhr? && params[:username].blank?    
      slug = params[:slug].match(/^([A-Za-z0-9-]+)/i).to_s    
      @post = Post.find_by_slug(:slug => slug)
      @comment = Comment.new(params[:comment])        
      @comment.allow = false
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
      Navvy::Job.enqueue(SpamChecker, :comment_spam, @comment)   
      return ret
    else
      "This form only accpts a valid submission submitted via ajax. Please enable javascript in your browser and try again."
    end
  end
  
  # Validate Callback For Defensio
  post :validate, :map => '/comments/validate/:commentid' do   
    @comment = Comment.first(:id => params[:commentid]) 
    @post = Post.first(:id => @comment.post_id) 
    cdoc = params[:document]
    if cdoc.allow == false   
      @post.comment_count = @post.comment_count - 1         
      @post.save    
    elsif cdoc.allow == true
      @post.comment_count = @post.comment_count + 1   
      @post.save
    end        
    Comment.spam_update(@comment.id, cdoc.allow)
  end 

end