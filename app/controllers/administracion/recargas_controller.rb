class Administracion::RecargasController < ApplicationController
  
  before_action :authenticate_cuenta!
  before_action :autenticar_rol_administrador!
  
  def index
    render :locals => { :recargas => recargas }
  end
  
  def recargas
    Recarga.where(:borrado => {'$exists' => false}, :aceptado => {'$exists' => false}, :rechazado => {'$exists' => false})
  end
  
  def resource_name
    :recarga
  end
  
  def edit
    self.resource = Recarga.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = Recarga.where(:_id => params[:id]).first
    if params[:commit] == 'aceptar'
      params[:recarga][:aceptado] = true
    else
      params[:recarga][:rechazado] = true
    end
    if resource.update_attributes(params[:recarga])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Recarga procesada exitosamente.', _ubicacion: administracion_recargas_path } }
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