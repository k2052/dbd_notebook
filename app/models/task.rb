class Task
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Timestamps 

  # Keys   
  key :depth,          Integer, :default => 0
  key :path,           Array  
  key :thing_id,       ObjectId
  key :parent_id,      String   
  
  # Very special key nothing is ever save to it, only used during mapping.
  key :tasks,          Array
  
  key :title,          String
  key :status,         String
  key :note,           String   
  key :note_intro,     String
  key :start_date,     Date
  key :due_date,       Date 
  key :estimated_time, Float
  key :actual_time,    Float
  key :archived_date,  Date
  key :canceled_date,  Date
  key :priority,       Integer
  key :archived,       Boolean
  key :canceled,       Boolean    
  key :completed,      Boolean
  key :completed_date, Date
  key :repeating,      Boolean  
  timestamps! 
  
  # Associations   
  belongs_to :thing, :class_name => "Thing", :foreign_key => "thing_id"   
  many :tasks   
  
  # Callbacks. 
  before_save :set_path, :gen_note_intro    
  
  ##
  # Instance Methods.   
  #       
  
  # Is this a root node?
  def root?
    self.depth.zero?
  end        
  
  ##
  # Model/Collection Methods
  #  
  
  # Return an array of tasks, threaded.
  def self.threaded_with_field(post, field_name='updated_at')
    tasks = Task.all(:conditions => {:thing_id => post.id}, :order => "path asc, #{field_name} asc")       
    results, map  = [], {}
    tasks.each do |task|  
      if task.parent_id.blank?
        results << task
      else 
        map[task.parent_id] ||= []
        map[task.parent_id] << task      
      end
    end 
    assemble(results, map)        
  end   
  
  # We should use the map when looping through.
  # If the task has stuff in the map we ouput it into the parent.
  
  # Recursive method to loop over and map the tasks.
  def self.assemble(results, map)
    list = []
    results.each do |result|
      if map[result.id.to_s]  
        result[:tasks] += self.assemble(map[result.id.to_s], map) 
        list << result
      else   
        list << result
      end
    end
    list
  end
  
  private        
  
    def set_path 
      if !self.parent_id.blank?    
        parent        = Task.find(self.parent_id)      
        self.thing_id = parent.thing_id
        self.depth    = parent.depth + 1
        self.path     = parent.path              
        self.path     << parent.id.to_s   
      end     
    end   
    
    def gen_note_intro
      self.note_intro = self.note.truncate(5)
    end  
    
end