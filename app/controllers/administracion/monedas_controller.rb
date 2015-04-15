class Administracion::MonedasController < ApplicationController
  
  before_action :authenticate_cuenta!
  
  def index
    render :locals => { :monedas => monedas }
  end
  
  def monedas
    Moneda.where(:borrado => {'$exists' => false})
  end
  
  def resource_name
    :moneda
  end
  
  def new
    self.resource = Moneda.new
  end
  
  def create
    self.resource = Moneda.new(params[:moneda])
    if resource.save
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Moneda agregada exitosamente.', _ubicacion: administracion_monedas_path } }
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
    self.resource = Moneda.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = Moneda.where(:_id => params[:id]).first
    if params[:moneda][:borrado] != '1'
      params[:moneda].delete(:borrado)
    end
    if resource.update_attributes(params[:moneda])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Moneda editada exitosamente.', _ubicacion: administracion_monedas_path } }
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