class PlanDominio
  include Mongoid::CumanawsBase
  
  field :dominio, type: String
  field :territorio, type: String
  field :descripcion, type: String
  field :precio_anual, type: Integer
  field :borrado, type: Boolean
  
  validates_presence_of :dominio
  validates_uniqueness_of :dominio
  validates_presence_of :pais
  validates_presence_of :descripcion
  validates_presence_of :precio_anual
  
end