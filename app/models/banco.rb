class Banco
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :logo_src, type: String
  
end