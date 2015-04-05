class Organizacion
  include Mongoid::CumanawsBase

  field :tipo, type: String
  field :docid, type: String
  field :nombre, type: String
  
  has_many :emails, autosave: true
  has_many :telefonos, autosave: true
  
  field :pais, type: String
  field :entidad_federal, type: String
  field :localidad, type: String
  field :direccion, type: String
end