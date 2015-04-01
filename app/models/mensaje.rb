class Mensaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  field :tu_nombre, type: String
  field :tu_correo_electronico, type: String
  field :asunto, type: String
  field :contenido, type: String
  
end