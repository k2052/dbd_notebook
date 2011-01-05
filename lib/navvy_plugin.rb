module NavvyInitializer
  def self.registered(app)
    require 'navvy'
    require 'navvy/job/mongo_mapper' 
  end
end
