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
    registros=[]
    Dominio::Registro.where(:cuenta_id => cuenta_id, :dominio_id => _id, :borrado.exists => false).each do |registro|
      h_registro={:nombre => registro[:nombre], :tipo => registro[:tipo], :direccion => registro[:direccion]}
      if h_registro[:registro] == 'MX'
        h_registro[:prioridad] = registro[:_id] != self._id ? registro[:prioridad] : self.prioridad
      end
      registros.push(h_registro)
    end
    Terceros::ZoneFile.actualizar(self.nombre, self.plan_dominio[:dominio],registros)
  end
  
end