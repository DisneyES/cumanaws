class Persona
  include Mongoid::CumanawsBase
  
  field :docid, type: String
  field :nombre, type: String                    
  field :apellidos, type: String                 
  has_many :emails, autosave: true
  has_many :telefonos, autosave: true
  
  field :pais, type: String
  field :entidad_federal, type: String
  field :localidad, type: String
  field :direccion, type: String
  
  validates_presence_of :docid
  validates_presence_of :nombre
  validates_presence_of :apellidos
  
  belongs_to :cuenta
  
end