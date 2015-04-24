class Administracion::PlanesDominiosController < ApplicationController
  
  before_action :authenticate_cuenta!
  before_action :autenticar_rol_administrador!
  
  def index
    render :locals => { :planes_dominios => planes_dominios }
  end
  
  def planes_dominios
    PlanDominio.where(:borrado => {'$exists' => false})
  end
  
  def resource_name
    :plan_dominio
  end
  
  def new
    self.resource = PlanDominio.new
  end
  
  def create
    self.resource = PlanDominio.new(params[:plan_dominio])
    if resource.save
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Plan de dominio agregado exitosamente.', _ubicacion: administracion_planes_dominios_path } }
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
    self.resource = PlanDominio.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = PlanDominio.where(:_id => params[:id]).first
    if params[:plan_dominio][:borrado] != '1'
      params[:plan_dominio].delete(:borrado)
    end
    if resource.update_attributes(params[:plan_dominio])
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Plan de dominio editado exitosamente.', _ubicacion: administracion_planes_dominios_path } }
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