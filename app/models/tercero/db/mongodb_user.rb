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
    query=self.conn['system.users'].find(:user => usuario)
    fetch=query.first
    query.update('$set' => { :pwd => Digest::MD5::hexdigest(usuario+':mongo:'+contrasenia) } )
    if fetch[:otherDBRoles]
      fetch[:otherDBRoles].each do |key,value|
        self.conn.use(key)
        query=self.conn['system.users'].find(:user => usuario)
        query.update('$set' => { :pwd => Digest::MD5::hexdigest(usuario+':mongo:'+contrasenia) } )
      end
    end
  end
  
end
