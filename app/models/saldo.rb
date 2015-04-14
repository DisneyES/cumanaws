class Saldo
  include Mongoid::CumanawsBase
  
  field :espera, type: Float, default: 0
  field :activo, type: Float, default: 0
  
  belongs_to :cuenta
  
end