Admin.controllers :things do

  get :index do
    @things = Thing.all
    render 'things/index'
  end

  get :new do
    @thing = Thing.new
    render 'things/new'
  end

  post :create do
    @thing = Thing.new(params[:thing])
    if @thing.save
      flash[:notice] = 'Thing was successfully created.'
      redirect url(:things, :edit, :id => @thing.id)
    else
      render 'things/new'
    end
  end

  get :edit, :with => :id do
    @thing = Thing.find(params[:id])   
    render 'things/edit'
  end

  put :update, :with => :id do
    @thing = Thing.find(params[:id])
    if @thing.update_attributes(params[:thing])
      flash[:notice] = 'Thing was successfully updated.'
      redirect url(:things, :edit, :id => @thing.id)
    else
      render 'things/edit'
    end
  end

  delete :destroy, :with => :id do
    thing = Thing.find(params[:id])
    if thing.destroy
      flash[:notice] = 'Thing was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Thing!'
    end
    redirect url(:things, :index)
  end  
  
end