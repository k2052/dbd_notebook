module AssetHatInitializer
  def self.registered(app)     
    require 'asset_hat.rb'
    require 'asset_hat_helper'   
    require 'asset_hat_sinatra' 
    app.register AssetHat::Sinatra  
	end  
end