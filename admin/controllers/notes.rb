Admin.controllers :notes do

  get :index do
    @notes = Note.all
    render 'notes/index'
  end

  get :new do
    @note = Note.new
    render 'notes/new'
  end

  post :create do
    @note = Note.new(params[:note])
    if @note.save
      flash[:notice] = 'Note was successfully created.'
      redirect url(:notes, :edit, :id => @note.id)
    else
      render 'notes/new'
    end
  end

  get :edit, :with => :id do
    @note = Note.find(params[:id])
    render 'notes/edit'
  end

  put :update, :with => :id do
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = 'Note was successfully updated.'
      redirect url(:notes, :edit, :id => @note.id)
    else
      render 'notes/edit'
    end
  end

  delete :destroy, :with => :id do
    note = Note.find(params[:id])
    if note.destroy
      flash[:notice] = 'Note was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Note!'
    end
    redirect url(:notes, :index)
  end    
  
end