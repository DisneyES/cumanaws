class Hospedaje::AplicacionWeb
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :hospedaje
  belongs_to :dominio_registro, class_name: 'Dominio::Registro'
  
  field :nombre, type: String
  field :lenguaje, type: String # nodejs, php, python, ruby
  field :framework, type: String
  field :app_server, type: String # php-fpm, unicorn, gunicorn, nodejs
  field :dir, type: String
  field :entorno, type: String # production, development, text, etc...
  
  field :activado, type: Boolean
  field :borrado, type: Boolean
  
  field :suspendido, type: Boolean
  
  before_create :instalar
  
  protected
  
  # To create directories and do other stuff necessary to run the app
  def instalar
    
  end
  
end
