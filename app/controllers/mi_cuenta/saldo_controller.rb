class MiCuenta::SaldoController < ApplicationController
  
  before_action :authenticate_cuenta!
  
  def index
    
  end
  
  def resource_name
    :recarga
  end
  
  def new
    self.resource = Recarga.new
  end
  
  def create
    self.resource = Recarga.new(params[:recarga])
    if resource.save
      respond_with resource do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Recarga registrada exitosamente.', _ubicacion: mi_cuenta_saldo_path } }
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