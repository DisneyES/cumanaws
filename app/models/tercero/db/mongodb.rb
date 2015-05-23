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
    self.conn['system.users'].find(:user => usuario ).update( '$set' => { :otherDBRoles => { nombre => ['dbAdmin','readWrite'] } } )
    self.conn.use(nombre)
  end
  
end
