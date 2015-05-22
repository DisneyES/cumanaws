# Manage third party PgSQL users
class Tercero::Db::PgsqlUser
  
  # To initialize the class
  def initialize
    self.conn = PG.connect(:hostaddr => '127.0.0.1', :port => '5432', :user => AppConfig.aplicacion.db.pgsql.user, :password => AppConfig.aplicacion.db.pgsql.password)
  end
  
  # To create user
  def self.crear(usuario,contrasenia)
    self.conn('CREATE USER '+usuario+' WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD \''+contrasenia+'\'')
  end
  
  # To update user
  def self.cambiar_contrasenia(usuario,contrasenia)
    self.conn('ALTER USER '+usuario+' ENCRYPTED PASSWORD \''+contrasenia+'\'')
  end
  
end
