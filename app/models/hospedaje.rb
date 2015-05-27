class Hospedaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_hospedaje
  
  field :nro, type: Integer
  
  has_many :hospdaje_aplicaciones_web, class_name: 'Hospedaje::AplicacionWeb'
  has_many :hospdaje_db_user, class_name: 'Hospedaje::DbUser'
  has_many :hospdaje_db, class_name: 'Hospedaje::Db'
  
  field :borrado, type: Boolean
  field :expirado, type: Boolean
  
  before_create :instalar
  
  protected
  
  # To create directories and do other stuff necessary to activate the web hosting
  def instalar
    # Crear grupo y usuario por defecto
    system('useradd -m '+self._id)
    Dir.mkdir('/home/'+self._id+'/log')      # Directorio donde se almacenan los logs
    Dir.mkdir('/home/'+self._id+'/mail')     # Directorio donde se almacenan los correos
    
    # Asignar gestores de bases de datos
    Dir.mkdir('/home/'+self._id+'/db')       # Directorio donde se almacenan las bases de datos
    
    Dir.mkdir('/home/'+self._id+'/db/pgsql') # Directorio donde se almacenan las bases de datos PostgreSQL
    Tercero::Db::Pgsql::crear_tablespace(self._id, '/home/'+self._id+'/db/pgsql')
    
    Dir.mkdir('/home/'+self._id+'/db/mysql') # Directorio donde se almacenan las bases de datos MySQL
    
    Dir.mkdir('/home/'+self._id+'/db/mongo') # Directorio donde se almacenan las bases de datos MongoDB
    
    # Asignar acceso por FTP
    Dir.mkdir('/home/'+self._id+'/pub')     # Directorio donde se almacenan los archivos accesibles desde FTP o HTTP/HTTPS
    
    # Asignar permisos del usuario a los directorios creados 
    FileUtils.chown(self._id, self._id, '/home/'+self._id);
    FileUtils.chmod_R(0700, '/home/'+self._id)
    
    # Crear un host con algo como 'h'+self.nro+'.'+app_host asociado a este hospedaje web
    zona = File.open('/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone', 'w')
    zona.puts 'wh'+self.nro+' CNAME '+AppConfig.aplicacion.host+'.'
    zona.close
    
  end
  
end