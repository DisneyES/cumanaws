class Administracion::CuentasBancariasController < ApplicationController
  
  before_action :authenticate_cuenta!
  before_action :autenticar_rol_administrador!
  
  def index
    render :locals => { :ctas_bancarias => ctas_bancarias }
  end
  
  def ctas_bancarias
    CuentaBancaria.where(:borrado => {'$exists' => false})
  end
  
  def resource_name
    :cuenta_bancaria
  end
  
  def new
    self.resource = CuentaBancaria.new
  end
  
  def create
    self.resource = CuentaBancaria.new(params[:cuenta_bancaria])
    if resource.save
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Cuenta bancaria agregada exitosamente.', _ubicacion: administracion_cuentas_bancarias_path } }
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
  
  def edit
    self.resource = CuentaBancaria.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = CuentaBancaria.where(:_id => params[:id]).first
    if params[:cuenta_bancaria][:borrado] != '1'
      params[:cuenta_bancaria].delete(:borrado)
    end
    if resource.update_attributes(params[:cuenta_bancaria])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Cuenta bancaria editada exitosamente.', _ubicacion: administracion_cuentas_bancarias_path } }
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