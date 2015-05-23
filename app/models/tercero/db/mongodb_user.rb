# Manage third party MongoDB users
class Tercero::Db::MongodbUser
  
  # To initialize the class
  def initialize
    self.conn = Moped::Session.new(["127.0.0.1:27017"])
  end
  
  # To create user
  def self.crear(usuario,contrasenia)
    self.conn.use('admin')
    self.conn.auth(AppConfig.aplicacion.db.mongodb.user,AppConfig.aplicacion.db.mongodb.password)
    self.conn['system.users'].insert(:user => usuario, :pwd => Digest::MD5::hexdigest(usuario+':mongo:'+contrasenia), :roles => [] )
  end
  
  # To update user
  def self.cambiar_contrasenia(usuario,contrasenia)
    self.conn.use('admin')
    self.conn.auth(AppConfig.aplicacion.db.mongodb.user,AppConfig.aplicacion.db.mongodb.password)
    self.conn['system.users'].find(:user => usuario).update('$set' => { :pwd => Digest::MD5::hexdigest(usuario+':mongo:'+contrasenia), :roles => [] } )
  end
  
end
