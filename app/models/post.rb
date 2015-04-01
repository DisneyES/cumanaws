class Post
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
end