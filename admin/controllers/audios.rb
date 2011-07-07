Admin.controllers :audios do

  get :index do
    @audios = Audio.all
    render 'audios/index'
  end

  get :new do
    @audio = Audio.new
    render 'audios/new'
  end

  post :create do
    @audio = Audio.new(params[:audio])
    if @audio.save
      flash[:notice] = 'Audio was successfully created.'
      redirect url(:audios, :edit, :id => @audio.id)
    else
      render 'audios/new'
    end
  end

  get :edit, :with => :id do
    @audio = Audio.find(params[:id])  
    @commentary = @audio.commentary
    render 'audios/edit'
  end

  put :update, :with => :id do
    @audio = Audio.find(params[:id])
    if @audio.update_attributes(params[:audio])
      flash[:notice] = 'Audio was successfully updated.'
      redirect url(:audios, :edit, :id => @audio.id)
    else
      render 'audios/edit'
    end
  end

  delete :destroy, :with => :id do
    audio = Audio.find(params[:id])
    if audio.destroy
      flash[:notice] = 'Audio was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Audio!'
    end
    redirect url(:audios, :index)
  end  
  
  post :upload_audio, :with => :id do 
    @audio = Audio.find(params[:id]) 
    @audio.file = params[:file]  
    @audio.save       
  end  
end