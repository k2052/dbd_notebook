Admin.controllers :commentaries do

  put :create, :map => '/commentaries/create/:type/:pid' do           
    classname          = Module.const_get(params[:type])  
    @parent            = classname.send(:find, params[:pid]) 
    @commentary        = Commentary.new({:body_src => params[:body_src]}) 
    @parent.commentary = @commentary
    if @parent.save
      flash[:notice] = 'Commentary was successfully created.'
      redirect url(params[:type].downcase.pluralize.to_sym, :edit, :id => @parent.id)
    else
      flash[:notice] = 'Commentary creation failed.'
      redirect url(params[:type].downcase.pluralize.to_sym :edit, :id => @parent.id)
    end
  end
   
  # Use a save instead of update because I'm lazy.
  put :update, :map => '/commentaries/update/:type/:pid' do
    classname          = Module.const_get(params[:type])  
    @parent            = classname.send(:find, params[:pid])   
    @commentary        = Commentary.new(params[:commentary])   
    @parent.commentary = @commentary
    if @parent.save
      flash[:notice] = 'Commentary was successfully updated.'
      redirect url(params[:type].downcase.pluralize.to_sym, :edit, :id => @parent.id)
    else
      flash[:notice] = 'Commentary update failed.'
      redirect url(params[:type].downcase.pluralize.to_sym, :edit, :id => @parent.id)
    end
  end   
end