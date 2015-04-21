class Subdominio
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :dominio
  
  field :nombre, type: String
  field :registro, type: String
  
  # Para registros A, AAAA, CNAME y MX
  field :direccion, type: String
  
  # Para registro MX y CNAME
  belongs_to :subdominio
  
  # Para registro MX
  field :prioridad, type: String
  
  before_create :editar_zona
  before_update :editar_zona
  
  protected
  
  def editar_zona
    # Agregar nombre de subdominio al servidor DNS
  end
  
end