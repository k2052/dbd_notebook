Admin.controllers :galleries do

  get :index do
    @galleries = Gallery.all
    render 'galleries/index'
  end

  get :new do
    @gallery = Gallery.new
    render 'galleries/new'
  end

  post :create do
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:notice] = 'Gallery was successfully created.'
      redirect url(:galleries, :edit, :id => @gallery.id)
    else
      render 'galleries/new'
    end
  end

  get :edit, :with => :id do
    @gallery = Gallery.find(params[:id])
    render 'galleries/edit'
  end

  put :update, :with => :id do
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = 'Gallery was successfully updated.'
      redirect url(:galleries, :edit, :id => @gallery.id)
    else
      render 'galleries/edit'
    end
  end

  delete :destroy, :with => :id do
    gallery = Gallery.find(params[:id])
    if gallery.destroy
      flash[:notice] = 'Gallery was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Gallery!'
    end
    redirect url(:galleries, :index)
  end 
    
end