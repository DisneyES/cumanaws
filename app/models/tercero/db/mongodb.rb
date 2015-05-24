# Manage third party MongoDB databases
class Tercero::Db::Mongodb
  
  # To initialize the class
  def initialize
    self.conn = Moped::Session.new(["127.0.0.1:27017"])
  end
  
  # To create database
  def self.crear(nombre,homefolder,usuario)
    Dir.mkdir('/home/'+homefolder+'/db/mongo/'+nombre)
    File.symlink('/home/'+homefolder+'/db/mongo/'+nombre, '/var/lib/mongo/'+nombre)
    self.conn.use('admin')
    self.conn.auth(AppConfig.aplicacion.db.mongodb.user,AppConfig.aplicacion.db.mongodb.password)
    query=self.conn['system.users'].find(:user => usuario )
    pwd=query.first[:pwd]
    query.update( '$set' => { :otherDBRoles => { nombre => ['dbAdmin','readWrite'] } } )
    self.conn.use(nombre)
    self.conn['system.users'].insert( :user => usuario, :pwd => pwd, :roles => { nombre => ['dbAdmin','readWrite'] } )
  end
  
end
