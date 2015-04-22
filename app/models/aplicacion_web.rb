class AplicacionWeb
  include Mongoid::CumanawsBase
  
  field :nombre, type: String
  field :app_server, type: String # php-fpm, unicorn, gunicorn, nodejs
  field :dir, type: String
  field :entorno, type: String # production, development, text, etc...
  
  field :enviado, type: Boolean
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  field :borrado, type: Boolean
  
  before_create :instalar
  
  protected
  
  # To create directories and do other stuff necessary to run the app
  def instalar
    
  end
  
end
