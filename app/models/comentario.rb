class Comentario
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
end