class Moneda
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :codigo, type: String
  field :simbolo, type: String
  field :conversion, type: Float
  field :borrado, type: Boolean
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  validates_presence_of :codigo
  validates_uniqueness_of :codigo
  validates_presence_of :simbolo
  validates_uniqueness_of :simbolo
  validates_presence_of :conversion
  
end