# Manage third party MongoDB databases
class Tercero::Db::Mongodb
  
  # To initialize the class
  def initialize
    self.conn = Moped::Session.new(["127.0.0.1:27017"])
  end
  
  # To create database
  def self.crear(nombre,homefolder,user,password)
    Dir.mkdir('/home/'+homefolder+'/db/mongo/'+nombre)
    File.symlink('/home/'+homefolder+'/db/mongo/'+nombre, '/var/lib/mongo/'+nombre)
    self.conn.use(nombre)
    self.conn['system.users'].insert(:user => user,
        :readOnly => false,
        :pwd => Digest::MD5::hexdigest(user+':mongo:'+password) )
  end
  
end
