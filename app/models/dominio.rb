class Dominio
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_dominio
  
  field :nombre, type: String
  
  has_many :dominios_registros, class_name: 'Dominio::Registro'
  
  before_create :crear_zona
  before_update :editar_zona
  before_update :editar_zona
  
  protected
  
  def crear_zona
    Terceros::ZoneFile.crear(self.nombre, self.plan_dominio[:dominio])
  end
  
  def editar_zona
    subdominios=[]
    Subdominio.where(:cuenta_id => cuenta_id, :dominio_id => _id, :borrado.exists => false).each do |subdominio|
      h_subdominio={:nombre => subdominio[:nombre], :registro => subdominio[:registro], :direccion => subdominio[:direccion]}
      if h_subdominio[:registro] == 'MX'
        h_subdominio[:prioridad] = subdominio[:prioridad]
      end
      subdominios.push(h_subdominio)
    end
    Terceros::ZoneFile.actualizar(self.nombre, self.plan_dominio[:dominio],subdominios)
  end
  
end