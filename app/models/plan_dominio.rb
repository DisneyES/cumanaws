class PlanDominio
  include Mongoid::CumanawsBase
  
  field :dominio, type: String
  field :pais, type: String
  field :descripcion, type: String
  field :precio_anual, type: Integer
  
end