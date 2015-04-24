class AdministracionController < ApplicationController
  
  before_action :authenticate_cuenta!
  before_action :autenticar_rol_administrador!
  
  def index
    
  end
  
end