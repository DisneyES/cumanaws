class PlanHospedaje
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :espacio, type: Integer
  field :precio_mensual, type: Integer
  field :precio_anual, type: Integer
  
end