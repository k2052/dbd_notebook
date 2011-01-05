MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'dbd_notebook_development'
  when :production  then MongoMapper.database = 'dbd_notebook_production'
  when :test        then MongoMapper.database = 'dbd_notebook_test'
end