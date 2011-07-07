Admin.controllers :quotes do

  get :index do
    @quotes = Quote.all
    render 'quotes/index'
  end

  get :new do
    @quote = Quote.new
    render 'quotes/new'
  end

  post :create do
    @quote = Quote.new(params[:quote])
    if @quote.save
      flash[:notice] = 'Quote was successfully created.'
      redirect url(:quotes, :edit, :id => @quote.id)
    else
      render 'quotes/new'
    end
  end

  get :edit, :with => :id do
    @quote = Quote.find(params[:id])
    render 'quotes/edit'
  end

  put :update, :with => :id do
    @quote = Quote.find(params[:id])
    if @quote.update_attributes(params[:quote])
      flash[:notice] = 'Quote was successfully updated.'
      redirect url(:quotes, :edit, :id => @quote.id)
    else
      render 'quotes/edit'
    end
  end

  delete :destroy, :with => :id do
    quote = Quote.find(params[:id])
    if quote.destroy
      flash[:notice] = 'Quote was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Quote!'
    end
    redirect url(:quotes, :index)
  end  
end