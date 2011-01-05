# Load Heroku Env Vars.
heroku_env = File.join(File.dirname(__FILE__), 'heroku_env.rb')
load(heroku_env) if File.exists?(heroku_env)