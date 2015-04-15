class Fondo
  include Mongoid::CumanawsBase
  
  belongs_to :moneda
  field :espera, type: Intger, default: 0
  field :activo, type: Integer, default: 0
  
end