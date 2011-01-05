Admin.controllers :defaults do

  get :index do
    @defaults = Default.all
    render 'defaults/index'
  end

  get :new do
    @default = Default.new
    render 'defaults/new'
  end

  post :create do
    @default = Default.new(params[:default])
    if @default.save
      flash[:notice] = 'Default was successfully created.'
      redirect url(:defaults, :edit, :id => @default.id)
    else
      render 'defaults/new'
    end
  end

  get :edit, :with => :id do
    @default = Default.find(params[:id])
    render 'defaults/edit'
  end

  put :update, :with => :id do
    @default = Default.find(params[:id])
    if @default.update_attributes(params[:default])
      flash[:notice] = 'Default was successfully updated.'
      redirect url(:defaults, :edit, :id => @default.id)
    else
      render 'defaults/edit'
    end
  end

  delete :destroy, :with => :id do
    default = Default.find(params[:id])
    if default.destroy
      flash[:notice] = 'Default was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Default!'
    end
    redirect url(:defaults, :index)
  end   
  
end