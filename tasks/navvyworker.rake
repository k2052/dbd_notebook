# Starts up Navvy 
# See: http://github.com/jeffkreeftmeijer/navvy
task :navvy => :environment do  
  require 'navvy'
  require 'navvy/job/mongo_mapper'
  Navvy::Worker.start
end