Admin.controllers :comments do

  get :index do
    @comments = Comment.all
    render 'comments/index'
  end  
  
  get :flagged do
    @comments = Comment.flagged_comments 
    render 'comments/index'
  end

  get :spam, :with => :id do
    if Comment.mark_as_spam(params[:id])
      flash[:notice] = 'Comment was marked as spam'
    else
      flash[:notice] = 'Comment spam marking failed.'
    end
    redirect url(:comments, :index)
  end   
  
  get :notspam, :with => :id do
    if Comment.unmark_as_spam(params[:id])
      flash[:notice] = 'Comment was marked as not spam'
    else
      flash[:notice] = 'Comment spam unmarking failed.'
    end
    redirect url(:comments, :index)
  end

  get :new do
    @comment = Comment.new
    render 'comments/new'
  end

  post :create do
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect url(:comments, :edit, :id => @comment.id)
    else
      render 'comments/new'
    end
  end

  get :edit, :with => :id do
    @comment = Comment.find(params[:id])
    render 'comments/edit'
  end

  put :update, :with => :id do
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment was successfully updated.'
      redirect url(:comments, :edit, :id => @comment.id)
    else
      render 'comments/edit'
    end
  end

  delete :destroy, :with => :id do
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:notice] = 'Comment was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Comment!'
    end
    redirect url(:comments, :index)
  end  
end