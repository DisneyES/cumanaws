class Administracion::PlanesHospedajeController < ApplicationController
  
  def index
    render :locals => { :planes_hospedaje => planes_hospedaje }
  end
  
  def planes_hospedaje
    PlanHospedaje.where(:borrado => {'$exists' => false})
  end
  
  def resource_name
    :plan_hospedaje
  end
  
  def new
    self.resource = PlanHospedaje.new
  end
  
  def create
    self.resource = PlanHospedaje.new(params[:plan_hospedaje])
    if resource.save
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Plan de hospedaje web agregado exitosamente.', _ubicacion: administracion_planes_hospedaje_path } }
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
    self.resource = PlanHospedaje.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = PlanHospedaje.where(:_id => params[:id]).first
    if resource.update_attributes(params[:plan_hospedaje])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Plan de hospedaje web editado exitosamente.', _ubicacion: administracion_planes_hospedaje_path } }
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