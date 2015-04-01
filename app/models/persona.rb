class Persona
  include Mongoid::CumanawsBase
  
  embeds_many :docs_id
  
  field :pais, type: String
  field :idioma, type: String
  field :moneda, type: String
  
  field :nombre, type: String                    
  field :apellidos, type: String                 
  has_many :emails, autosave: true
  has_many :telefonos, autosave: true
  
  field :entidad_federal, type: String
  field :localidad, type: String
  field :direccion, type: String
  
  validates_presence_of :nombre
  validates_presence_of :apellidos
  
  #accepts_nested_attributes_for :doc_ids, reject_if: :all_blank
  #accepts_nested_attributes_for :emails, reject_if: :all_blank
  #accepts_nested_attributes_for :telefonos, reject_if: :all_blank
  
end