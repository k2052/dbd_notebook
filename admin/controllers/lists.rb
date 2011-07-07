Admin.controllers :lists do

  get :index do
    @lists = List.all
    render 'lists/index'
  end

  get :new do
    @list = List.new
    render 'lists/new'
  end

  post :create do   
    @list = List.new(params[:list])
    if @list.save 
      flash[:notice] = 'List was successfully created.'
    else   
      flash[:notice] = 'List creation failed.'
    end
    redirect url(:things, :edit, :id => @list.thing_id)    
  end

  get :edit, :with => :id do
    @list = List.find(params[:id])
    render 'lists/edit'
  end 

  put :update, :with => :id do    
    @list = List.find(params[:id])
    if @list.update_attributes(params[:list])      
      flash[:notice] = 'List was successfully updated.'
    else   
      flash[:notice] = 'List update failed.'
    end   
    redirect url(:things, :edit, :id => @list.thing_id)    
  end  

  delete :destroy, :with => :id do 
    @list = List.find(params[:id])
    if @list.destroy
      flash[:notice] = 'List was successfully destroyed.'
    else
      flash[:notice] = 'List destruction failed. Maybe get a better death star? Without the weak spot?'
    end
    redirect url(:things, :edit, :id => @list.thing_id)    
  end 
end