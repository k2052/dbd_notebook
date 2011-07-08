class DbdNotebook < Padrino::Application    
  
  ##
  # Intializers
  #
  register Padrino::Helpers   
  register Padrino::Rendering   
  
  # Resources. JS, CSS handling ext
  register CompassInitializer
  register AssetHatInitializer      
end