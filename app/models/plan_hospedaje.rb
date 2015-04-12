class PlanHospedaje
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :espacio, type: Integer
  field :descripcion, type: String
  field :precio_mensual, type: Integer
  field :precio_anual, type: Integer
  field :borrado, type: Boolean
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  validates_presence_of :espacio
  validates_presence_of :descripcion
  validates_presence_of :precio_mensual
  validates_presence_of :precio_anual
end