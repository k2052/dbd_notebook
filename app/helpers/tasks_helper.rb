DbdNotebook.helpers do    
  
  # Recursively loops over tasks. 
  # Used for outputting the task threads. 
  # You need to make sure you have set a instance var called @tasks_render before using this method.
  # Then to output the tasks jsut use %elem= @tasks_render
  def loop_tasks(tasks)  
    tasks.each_with_index do |@task, index|       
      if !@task.note.blank?    
        @tasks_render += "<li id='#{@task.id}' class='task note'>"     
      else
        @tasks_render += "<li id='#{@task.id}' class='task'>"     
      end
      @tasks_render += partial "tasks/task"     
      if !@task['tasks'].empty?   
        @tasks_render += "<ul class='depth_#{@task.depth}'>"
        loop_tasks(@task['tasks'])     
        @tasks_render += '</ul>'   
        @tasks_render += '</li>'   
      else 
        @tasks_render += '</li>'   
      end
    end
  end   
  
end