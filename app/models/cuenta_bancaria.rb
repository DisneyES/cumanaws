class CuentaBancaria
  include Mongoid::CumanawsBase
  
  belongs_to :banco
  field :nro, type: String
  field :tipo, type: String
  field :titular, type: String
  field :monedas, type: Array
  
end