class Fondo
  include Mongoid::CumanawsBase
  
  belongs_to :moneda
  field :espera, type: Float, default: 0
  field :activo, type: Float, default: 0
  
end