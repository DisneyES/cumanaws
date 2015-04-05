class ApplicationController < ActionController::Base
  
  #protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :variables_globales
  
  respond_to :json, :html
  
  helpers = %w(resource resource_name)
  hide_action *helpers
  helper_method *helpers
  
  def resource
    instance_variable_get(:"@#{resource_name}")
  end
  
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end
    
  protected

  def variables_globales
    $remote_ip = request.remote_ip 
    $cuenta_signed_in = cuenta_signed_in?
    $cuenta = current_cuenta
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :password, :password_confirmation, :docid, :nombre, :apellidos, :email, :telefono, :pais, :entidad_federal, :localidad, :direccion, :humanizer_answer, :humanizer_question_id, :terminos) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :password, :password_confirmation, :current_password) }
  end
  
end
