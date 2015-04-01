class Dominio
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  field :nombre, type: String
  field :dominio, type: String
  
end