class Fondo
  include Mongoid::CumanawsBase
  
  field :moneda, type: String
  field :espera, type: Intger, default: 0
  field :activo, type: Integer, default: 0
  
end