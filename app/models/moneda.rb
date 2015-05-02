class Moneda
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :codigo, type: String
  field :simbolo, type: String
  field :delimitador, type: String
  field :separador, type: String
  field :conversion, type: Float
  field :conversion_desde, type: DateTime
  embeds_many :conversiones_anteriores
  field :borrado, type: Boolean
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  validates_presence_of :codigo
  validates_uniqueness_of :codigo
  validates_presence_of :simbolo
  validates_uniqueness_of :simbolo
  validates_presence_of :delimitador
  validates_presence_of :separador
  validates_presence_of :conversion
  
end