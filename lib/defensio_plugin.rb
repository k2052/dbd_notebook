# Plugin for defensio 
# See http://github.com/dvyjones/defender
module DefenderInitializer
  def self.registered(app)
    require 'defender'
    Defender.api_key = ENV['DEFENSIO_KEY']
  end
end
