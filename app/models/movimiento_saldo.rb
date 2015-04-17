class MovimientoSaldo
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :recarga
  belongs_to :orden_compra
  
  field :saldo, type: Float
  field :tipo, type: Boolean
  field :descripcion, type: String
  field :motivo, type: String # recarga, compra
  field :cancelado_desde, type: DateTime
  field :cancelado_hasta, type: DateTime
  
end