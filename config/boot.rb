# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)

begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Bundler.require(:default, PADRINO_ENV.to_sym)
puts "=> Located #{Padrino.bundle} Gemfile for #{Padrino.env}"

##
# Add here your before load hooks
#
Padrino.before_load do     
  # Load App Specific Config
  my_config = File.join(File.dirname(__FILE__), 'config.rb')
  load(my_config) if File.exists?(my_config)
end

##
# Add here your after load hooks
#
Padrino.after_load do
end

Padrino.load!    