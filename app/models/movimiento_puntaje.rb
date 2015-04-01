class MovimientoPuntaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :recarga
  belongs_to :articulo_carrito
  
  field :puntos, type: Integer
  field :tipo, type: Boolean
  field :descripcion, type: String
  field :motivo, type: Integet
  field :cancelado_desde, type: Datetime
  field :cancelado_hasta, type: Datetime
  
end