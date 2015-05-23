# Manage third party MySQL databases
class Tercero::Db::Mysql
  
  # To initialize the class
  def initialize
    self.conn = Mysql2::Client.new(:host => '127.0.0.1', :port => 3306,  :username => AppConfig.aplicacion.db.user, :password => AppConfig.aplicacion.db.mysql.password)
  end
  
  # To create database
  def self.crear(nombre,homefolder,usuario)
    Dir.mkdir('/home/'+homefolder+'/db/mysql/'+nombre)
    File.symlink('/home/'+homefolder+'/db/mysql/'+nombre, '/var/lib/mysql/'+nombre)
    self.conn.query('CREATE DATABASE '+nombre)
    self.conn.query('GRANT ALL PRIVILEGES ON '+nombre+'.* to '+usuario+'@localhost')
    self.conn.query('FLUSH PRIVILEGES')
  end
  
end
