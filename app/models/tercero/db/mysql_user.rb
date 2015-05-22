# Manage third party MySQL users
class Tercero::Db::MysqlUser
  
  # To initialize the class
  def initialize
    self.conn = Mysql2::Client.new(:host => '127.0.0.1', :port => 3306,  :username => AppConfig.aplicacion.db.user, :password => AppConfig.aplicacion.db.mysql.password)
  end
  
  # To create user
  def self.crear(usuario,contrasenia)
    self.conn('CREATE USER '+usuario+'@localhost IDENTIFIED BY \''+contrasenia+'\'')
  end
  
  # To update user
  def self.cambiar_contrasenia(usuario,contrasenia)
    self.conn('SET PASSWORD FOR '+usuario+'@localhost = PASSWORD(\''+contrasenia+'\')')
  end
  
end
