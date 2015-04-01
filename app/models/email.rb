class Email
  include Mongoid::CumanawsBase
  
  field :email, type: String
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  
  belongs_to :persona
  belongs_to :organizacion
  
end