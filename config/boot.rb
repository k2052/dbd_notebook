# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)
# Load Bundler
require 'rubygems' unless defined?(Gem)
require 'bundler'
# Only have default and environemtn gems
Bundler.setup(:default, PADRINO_ENV.to_sym)
# Only require default and environment gems
Bundler.require(:default, PADRINO_ENV.to_sym)
puts "=> Located #{Padrino.bundle} Gemfile for #{Padrino.env}"

##
# Add here your before load hooks
#
Padrino.before_load do  
  # Load Some Environment Vars
  env_vars = File.join(File.dirname(__FILE__), 'heroku_env.rb')
  load(env_vars) if File.exists?(env_vars)
end

##
# Add here your after load hooks
#
Padrino.after_load do
end

Padrino.load! 