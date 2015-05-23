# Manage third party PgSQL databases
class Tercero::Db::Pgsql
  
  # To initialize the class
  def initialize
    self.conn = PG.connect(:hostaddr => '127.0.0.1', :port => '5432', :user => AppConfig.aplicacion.db.pgsql.user, :password => AppConfig.aplicacion.db.pgsql.password)
  end
  
  # To create tablespace
  def self.crear_tablespace(nombre,directorio)
    self.conn.exec('CREATE TABLESPACE '+nombre+' LOCATION '+directorio)
  end
  
  # To create database
  def self.crear(nombre,tablespace,usuario)
    self.conn.exec('CREATE DATABASE '+nombre+' WITH OWNER '+usuario+' TABLESPACE '+tablespace)
  end
  
end
