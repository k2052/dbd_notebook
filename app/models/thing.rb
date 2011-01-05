class Thing < Post
  include MongoMapper::Document
  
  # All Keys Inherited From Post Model    
  
  # Key Settings
  slug_key :title, :unique => true

  # Associations
  many :lists, :dependent => :destroy,  :class_name => "List"    
  many :tasks, :dependent => :destroy,  :class_name => "Task"          
  
  ##
  # Import methods. These Work hand in hand with the api and my local ruby scripts.
  #             
  
  def self.hit_list_import(thing)
    thing = JSON.parse(thing) 
    old = Thing.first(:title => thing['name'])   
    if old
      @thing = old
    else   
      @thing = Thing.new()
      @thing.title = thing['name']    
      @thing.save
    end  
    if old  
      if thing['tasks']
        self.save_tasks_hit_list(thing['tasks'], nil, true) 
      else
        self.save_lists_hit_list(thing['lists'], nil, true) 
      end  
    else
      if thing['tasks']
        self.save_tasks_hit_list(thing['tasks'], nil) 
      else                                          
        self.save_lists_hit_list(thing['lists'], nil) 
      end    
    end
  end                                     
  
  private 
  
    ##
    # Import methods. These Work hand in hand with the api and my local ruby scripts.
    #         
    
    def self.save_tasks_hit_list(tasks, parent = nil, update = false)   
      tasks.each do |task|
        task_without_tasks = task[1] 
        has_tasks = task[1].include?('tasks')    
        sub_tasks =  task[1]['tasks']   
        unless parent.blank?
          parent_task = Task.first('title' => parent) 
          parent_id   = parent_task.id
        end    
        if has_tasks     
          task_without_tasks = task_without_tasks.delete_if {|key, value| key == 'tasks' }    
        end
        if update        
          task_save = Task.first(:title => task[1]['title'])   
        end   
        if !parent.blank? 
          if task_save
            task_save.update_attributes(task_without_tasks.merge(:thing_id => @thing.id, :parent_id => parent_id))
          else   
            task_save = Task.new(task_without_tasks.merge(:thing_id => @thing.id, :parent_id => parent_id))   
          end
        else  
          if task_save 
            task_save.update_attributes(task_without_tasks)   
          else       
            task_save = Task.new(task_without_tasks.merge(:thing_id => @thing.id))   
          end
        end   
        task_save.save   
        if has_tasks
          self.save_tasks_hit_list(sub_tasks, task[1]['title'], update)
        end 
      end
    end  
      
    def self.save_lists_hit_list(lists, parent = nil, update = false)   
      lists.each do |list|   
        list_without_lists = list[1] 
        has_lists = list[1].include?('lists')    
        sub_lists =  list[1]['lists']   
        unless parent.blank?
          parent_list = List.first(:title => parent) 
          parent_id   = parent_list.id
        end    
        if has_lists     
          list_without_lists = list_without_lists.delete_if {|key, value| key == 'lists' }    
        end
        if update        
          list_save = List.first(:title => list[1]['title'])   
        end   
        if !parent.blank? 
          if list_save
            list_save.update_attributes(list_without_lists.merge(:thing_id => @thing.id, :parent_id => parent_id))
          else   
            list_save = List.new(list_without_lists.merge(:thing_id => @thing.id, :parent_id => parent_id))   
          end
        else  
          if list_save 
            list_save.update_attributes(list_without_lists)   
          else
            list_save = List.new(list_without_lists.merge(:thing_id => @thing.id))   
          end
        end   
        list_save.save   
        if has_lists
          self.save_lists_hit_list(sub_lists, list[1]['title'], update)
        end 
      end
    end    
    
end