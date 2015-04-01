class DocId
  include Mongoid::CumanawsBase
  
  field :pais, type: String
  field :categoria, type: String
  field :codigo, type: String
  
end