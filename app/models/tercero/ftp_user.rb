class Tercero::FtpUser < ActiveRecord::Base
  
  validates_presence_of :username
  validates_length_of :username, minimum: 5, maximum: 20, allow_blank: true
  validates_format_of :username, :with => /\A[A-Za-z0-9_\-.]+\z/i, allow_blank: true, message: 'posee caracteres invalidos'
  validates_uniqueness_of :username
  
  validates_presence_of :password
  validates_length_of :password, minimum: 8, maximum: 128, allow_blank: true
  
end
