Admin.controllers :videos do

  get :index do
    @videos = Video.all
    render 'videos/index'
  end

  get :new do
    @video = Video.new
    render 'videos/new'
  end

  post :create do
    @video = Video.new(params[:video])
    if @video.save
      flash[:notice] = 'Video was successfully created.'
      redirect url(:videos, :edit, :id => @video.id)
    else
      render 'videos/new'
    end
  end

  get :edit, :with => :id do
    @video = Video.find(params[:id])
    render 'videos/edit'
  end

  put :update, :with => :id do
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      flash[:notice] = 'Video was successfully updated.'
      redirect url(:videos, :edit, :id => @video.id)
    else
      render 'videos/edit'
    end
  end

  delete :destroy, :with => :id do
    video = Video.find(params[:id])
    if video.destroy
      flash[:notice] = 'Video was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Video!'
    end
    redirect url(:videos, :index)
  end  
  
  post :upload_video, :with => :id do 
    @video = Video.find(params[:id]) 
    @video.file = params[:file]  
    @video.save       
  end
end