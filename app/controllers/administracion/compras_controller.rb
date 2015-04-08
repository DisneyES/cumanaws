class Administracion::ComprasController < ApplicationController
  
  before_action :authenticate_cuenta!
  
  def index
    render :locals => { :compras => compras }
  end
  
  def compras
    Compra.where(:borrado => {'$exists' => false}, :aceptado => {'$exists' => false}, :rechazado => {'$exists' => false}, :enviado => true)
  end
  
  def resource_name
    :compra
  end
  
  def edit
    self.resource = Compra.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = Compra.where(:_id => params[:id]).first
    if params[:compra][:commit] == 'aceptar'
      params[:compra][:aceptado] = true
    else
      params[:compra][:rechazado] = true
    end
    if resource.update_attributes(params[:compra])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Compra procesada exitosamente.', _ubicacion: administracion_compras_path } }
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