# Manage third party services
class Tercero::Servicio
  
  # To initialize the class
  def initialize
    
  end
  
  # To start a service
  def self.iniciar(nombre)
    system('systemctl','start',nombre+'.service')
  end
  
  # To stop a service
  def self.detener(nombre)
    system('systemctl','stop',nombre+'.service')
  end
  
  # To restart a service
  def self.reiniciar(nombre)
    system('systemctl','restart '+nombre+'.service')
  end
  
  # To reload a service
  def self.recargar(nombre)
    system('systemctl','reload '+nombre+'.service')
  end
  
  # To get the service status
  def self.estado(nombre)
    system('systemctl','-l','status',nombre+'.service')
  end
  
  # To execute other param of the service
  def self.ejecutar(nombre,param)
    system('systemctl',param,nombre+'.service')
  end
  
  # To get a list of the services
  def self.lista
    `systemctl -t service -a`
  end
  
end
