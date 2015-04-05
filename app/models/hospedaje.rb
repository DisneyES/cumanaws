class Hospedaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_hospedaje
  
  before_create :activar_servicio
  
  protected
  
  def activar_servicio
    # Crear carpetas
    
    # Crear grupo y usuario por defecto
    
    # Asignar cuota
    
    # Asignar servidores de aplicaciones
    
    # Asignar gestores de bases de datos
    
    # Asignar acceso por FTP
    
  end
  
end