class Organizacion
  include Mongoid::CumanawsBase
  
  field :pais, type: String
  
  field :tipo, type: String
  embeds_many :ids
  field :nombre, type: String
  
  has_many :emails, autosave: true
  has_many :telefonos, autosave: true
  
  field :entidad_federal, type: String
  field :localidad, type: String
  field :direccion, type: String
  
  belongs_to :cuenta
  
#  accepts_nested_attributes_for :doc_ids, reject_if: :all_blank
#  accepts_nested_attributes_for :emails, reject_if: :all_blank
#  accepts_nested_attributes_for :telefonos, reject_if: :all_blank
  
end