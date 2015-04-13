class Administracion::CuentasController < ApplicationController
  
  before_action :authenticate_cuenta!
  
  def index
    render :locals => { :cuentas => cuentas }
  end
  
  def cuentas
    Cuenta.where(:borrado => {'$exists' => false}, :suspendido => {'$exists' => false})
  end
  
  def resource_name
    :cuenta
  end
  
  def edit
    self.resource = Cuenta.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = Cuenta.where(:_id => params[:id]).first
    if params[:cuenta][:password].blank?
      params[:cuenta].delete(:password)
      params[:cuenta].delete(:password_confirmation) if params[:cuenta][:password_confirmation].blank?
    end
    if params[:cuenta][:suspendido] != '1'
      params[:cuenta].delete(:suspendido)
    end
    if resource.update_attributes(params[:cuenta])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Cuenta editada exitosamente.', _ubicacion: administracion_cuentas_path } }
      end
    else
      campos={}
      resource.errors.each do |error|
        campos[error]={_set: {error: resource.errors[error]} }
      end
      respond_with resource do |format|
        format.json {render :json => { _exito: false, _canterrores: resource.errors.count, _campos: campos} }
      end
    end
  end
  
end