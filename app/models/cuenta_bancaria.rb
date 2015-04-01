class CuentaBancaria
  include Mongoid::CumanawsBase
  
  field :empresa, type: String
  field :nro, type: String
  field :tipo, type: String
  field :titular, type: String
  field :monedas, type: Array
  
end