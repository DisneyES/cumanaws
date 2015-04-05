class Subdominio
  include Mongoid::CumanawsBase
  
  belongs_to :dominio
  
  before_create :activar_servicio
  
  protected
  
  def activar_servicio
    # Agregar nombre de subdominio al servidor DNS
  end
  
end