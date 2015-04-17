class OrdenCompra
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  field :nro, type: Integer
  
  has_many :compras, autosave: true
  
  field :precio_total, type: Float
  
  field :enviado, type: Boolean
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  field :borrado, type: Boolean
  
end
