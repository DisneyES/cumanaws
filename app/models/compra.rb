class Compra
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  belogns_to :orden_compra
  
  field :tmp_carrito, type: BSON::ObjectId
  
  belongs_to :plan_hospedaje
  belongs_to :plan_dominio
  
  belongs_to :hospedaje
  belongs_to :dominio
  
  field :duracion, type: Integer
  
  field :nombre, type: String   # para adquirir dominios
  
  field :precio, type: Float
  
  field :enviado, type: Boolean
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  field :borrado, type: Boolean
  
end