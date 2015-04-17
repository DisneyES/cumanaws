class MovimientoFondo
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :recarga
  belongs_to :dominio
  
  field :tipo, type: Boolean
  belongs_to :moneda
  field :monto, type: Float
  field :descripcion, type: String
  field :motivo, type: String
  field :cancelado_desde, type: DateTime
  field :cancelado_hasta, type: DateTime
  
end