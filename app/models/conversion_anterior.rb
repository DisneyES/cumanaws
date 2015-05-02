class ConversionAnterior
  include Mongoid::Document
  
  field :conversion, type: Float
  field :desde, type: DateTime
  field :hasta, type: DateTime
  
end
