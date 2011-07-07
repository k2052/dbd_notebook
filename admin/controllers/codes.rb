Admin.controllers :codes do

  get :index do
    @codes = Code.all
    render 'codes/index'
  end

  get :new do
    @code = Code.new
    render 'codes/new'
  end

  post :create do
    @code = Code.new(params[:code])
    if @code.save
      flash[:notice] = 'Code was successfully created.'
      redirect url(:codes, :edit, :id => @code.id)
    else
      render 'codes/new'
    end
  end

  get :edit, :with => :id do
    @code = Code.find(params[:id])
    render 'codes/edit'
  end

  put :update, :with => :id do
    @code = Code.find(params[:id])
    if @code.update_attributes(params[:code])
      flash[:notice] = 'Code was successfully updated.'
      redirect url(:codes, :edit, :id => @code.id)
    else
      render 'codes/edit'
    end
  end

  delete :destroy, :with => :id do
    code = Code.find(params[:id])
    if code.destroy
      flash[:notice] = 'Code was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Code!'
    end
    redirect url(:codes, :index)
  end  
end