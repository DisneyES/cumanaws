class Telefono
  include Mongoid::CumanawsBase
  
  field :telefono, type: String
  
  validates_presence_of :telefono
  validates_uniqueness_of :telefono
  
  belongs_to :persona
  belongs_to :organizacion
  
end