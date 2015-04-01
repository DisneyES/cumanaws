class Hospedaje
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  belongs_to :plan_hospedaje
  
end