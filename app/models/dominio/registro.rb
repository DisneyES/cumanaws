# A backup of register for de Zone File
class Dominio::Registro
  include Mongoid::CumanawsBase
  
  store_in collection: 'dominios_registros'
  
  belongs_to :cuenta
  belongs_to :dominio
  
  field :nombre, type: String
  field :tipo, type: String
  
  # Para registro MX
  field :prioridad, type: Integer
  
  # Para registros A, AAAA, CNAME y MX
  field :direccion, type: String
  
  before_create :insertar_datos
  before_create :editar_zona
  before_update :editar_zona
  
  protected
  
  def insertar_datos
    
  end
  
  def editar_zona
    registros=[]
    Dominio::Registro.where(:cuenta_id => self.cuenta_id, :dominio_id => self.dominio_id, :borrado.exists => false).each do |registro|
      if registro[:_id] != self._id
        h_registro={:nombre => registro[:nombre], :tipo => registro[:tipo], :direccion => registro[:direccion]}
      else
        h_registro={:nombre => self.nombre, :tipo => self.tipo, :direccion => self.direccion}
      end
      if h_registro[:registro] == 'MX'
        h_registro[:prioridad] = registro[:_id] != self._id ? registro[:prioridad] : self.prioridad
      end
      registros.push(h_registro)
    end
    Terceros::ZoneFile.actualizar(self.dominio.nombre, self.dominio.plan_dominio[:dominio], registros)
    
  end
  
end
