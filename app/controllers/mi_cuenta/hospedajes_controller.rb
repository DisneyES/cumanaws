class MiCuenta::HospedajesController < ApplicationController
  
  before_action :authenticate_cuenta!
  
  def index
    hospedajes = Hospedaje.where(:cuenta_id => current_cuenta._id,:borrado => {'$exists' => false},:expirado => {'$exists' => false})
    render :locals => { :hospedajes => hospedajes }
  end
  
end