class List
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Timestamps 

  # Keys
  key :title,      String  
  key :note,       String    
  key :note_intro, String
  timestamps!
  
  # Associations   
  belongs_to :thing   
  many :lists
  
  # Callbacks. 
  before_save :set_path    
  
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
  
  # Return an array of lists, threaded.
  def self.threaded_with_field(thing, field_name='created_at')
    lists = List.all(:conditions => {:thing_id => thing.id}, :order => "path asc, #{field_name} desc")
    results, map  = [], {}
    lists.each do |list|
      if list.parent_id.blank?
        results << list
      else
        map[list.parent_id] ||= []
        map[list.parent_id] << list      
      end
    end
    assemble(results, map)
  end
  
  # Recurssive method to loop over and map the lists.
  def self.assemble(results, map)
    list = []
    results.each do |result|
      if map[result.id.to_s]
        list << result
        list += assemble(map[result.id.to_s], map)
      else
        list << result
      end
    end
    list
  end
  
  ##
  # Methods that effect model data before save, after, or whenever.   
  # 

  private          
    def set_path 
      if !self.parent_id.blank?    
        parent        = List.find(self.parent_id)      
        self.thing_id = parent.thing_id
        self.depth    = parent.depth + 1
        self.path     = parent.path              
        self.path     << parent.id.to_s
      end     
    end
end