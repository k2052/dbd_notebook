Admin.controllers :tasks do

  get :index do
    @tasks = Task.all
    render 'tasks/index'
  end

  get :new do
    @task = Task.new
    render 'tasks/new'
  end

  post :create do   
    @task = Task.new(params[:task])
    if @task.save 
      flash[:notice] = 'Task was successfully created.'
    else   
      flash[:notice] = 'Task creation failed.'
    end
    redirect url(:things, :edit, :id => @task.thing_id)    
  end

  get :edit, :with => :id do
    @task = Task.find(params[:id])
    render 'tasks/edit'
  end 

  put :update, :with => :id do    
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])      
      flash[:notice] = 'Task was successfully updated.'
    else   
      flash[:notice] = 'Task update failed.'
    end   
    redirect url(:things, :edit, :id => @task.thing_id)    
  end  

  delete :destroy, :with => :id do 
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = 'Task was successfully destroyed.'
    else
      flash[:notice] = 'Task destruction failed. Maybe get a better death star? Without the weak spot?'
    end
    redirect url(:things, :edit, :id => @task.thing_id)    
  end
  
end