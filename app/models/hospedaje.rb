class Hospedaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_hospedaje
  
  before_create :activar_servicio
  
  protected
  
  def activar_servicio
    # Crear grupo y usuario por defecto
    system('useradd -m '+self._id)
    Dir.mkdir('/home/'+self._id+'/log')      # Directorio donde se almacenan los logs
    Dir.mkdir('/home/'+self._id+'/mail')     # Directorio donde se almacenan los correos
    
    # Asignar gestores de bases de datos
    Dir.mkdir('/home/'+self._id+'/db')       # Directorio donde se almacenan las bases de datos
    Dir.mkdir('/home/'+self._id+'/db/pgsql') # Directorio donde se almacenan las bases de datos PostgreSQL
    # Tablespace de PostgreSQL ('CREATE TABLESPACE '+self._id+' OWNER = '+self._id+' LOCATION \'/home/'+self._id+'/db/pgsql\'')
    Dir.mkdir('/home/'+self._id+'/db/mysql') # Directorio donde se almacenan las bases de datos MySQL
    #
    Dir.mkdir('/home/'+self._id+'/db/mongo') # Directorio donde se almacenan las bases de datos MongoDB
    #
    
    # Asignar acceso por FTP
    Dir.mkdir('/home/'+self._id+'/www')     # Directorio donde se almacenan los archivos accesibles desde FTP o HTTP/HTTPS
    
    # Asignar permisos del usuario a los directorios creados 
    FileUtils.chown(self._id, self._id, '/home/'+self._id);
    FileUtils.chmod_R(0700, '/home/'+self._id)
    
  end
  
end