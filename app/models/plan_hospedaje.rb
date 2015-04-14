class PlanHospedaje
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :espacio, type: Integer
  field :descripcion, type: String
  field :precio_mensual, type: Float
  field :precio_anual, type: Float
  field :precio_mb_adicional, type: Float
  field :borrado, type: Boolean
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  validates_presence_of :espacio
  validates_presence_of :descripcion
  validates_presence_of :precio_mensual
  validates_presence_of :precio_anual
  validates_presence_of :precio_mb_adicional
end