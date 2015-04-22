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
  field :prioridad, type: Integer
  
  before_create :editar_zona
  before_update :editar_zona
  
  protected
  
  def editar_zona
    subdominios=[]
    Subdominio.where(:cuenta_id => self.cuenta_id, :dominio_id => self.dominio_id, :borrado.exists => false).each do |subdominio|
      if subdominio[:_id] != self._id
        h_subdominio={:nombre => subdominio[:nombre], :registro => subdominio[:registro], :direccion => subdominio[:direccion]}
      else
        h_subdominio={:nombre => self.nombre, :registro => self.registro, :direccion => self.direccion}
      end
      if h_subdominio[:registro] == 'MX'
        h_subdominio[:prioridad] = subdominio[:_id] != self._id ? subdominio[:prioridad] : self.prioridad
      end
      subdominios.push(h_subdominio)
    end
    Terceros::ZoneFile.actualizar(self.dominio.nombre, self.dominio.plan_dominio[:dominio], subdominios)
    
  end
  
end