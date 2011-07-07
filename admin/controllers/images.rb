Admin.controllers :images do      
  
  post :create, :with => :pid do  
    @gallery = Gallery.find(params[:pid])  
    @image = Image.new
    @image.image = params[:file]
    @gallery.images << @image
    @gallery.save
  end  

  put :update, :with => :id, :with => :pid do    
    @imageID = BSON::ObjectId.from_string(params[:id])
    @image   = Image.new(params[:image])   
    if Gallery.collection.update({'images._id' => @imageID}, { '$set' => {'images.$.title' => @image.title, 'images.$.desc' => @image.desc}}) 
      flash[:notice] = 'Image was successfully updated.'
    else   
      flash[:notice] = 'Image update failed.'
    end   
    redirect url(:galleries, :edit, :id => params[:pid])    
  end  
  
  delete :destroy, :with => :id, :with => :pid do  
    if Image.delete(params[:id], params[:pid])
      flash[:notice] = 'Image was successfully destroyed.'
    else
      flash[:notice] = 'Image destruction failed. Maybe get a better death star? Without the weak spot?'
    end
    redirect url(:galleries, :edit, :id => params[:pid])    
  end   
end