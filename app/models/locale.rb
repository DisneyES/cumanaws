class Locale
  include Mongoid::CumanawsBase
  
  field :idioma, type: String, default: 'es'
  field :pais, type: String, default: 've'
  field :moneda, type: String, default: 'vef'
  
  belongs_to :cuenta
  
end