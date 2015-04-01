class CarritoController < ApplicationController
  
  def index
    render :locals => { :articulos => articulos }
  end
  
  def agregar
    a = ArticuloCarrito.new
    a.servicio = params[:servicio]
    a.plan = params[:plan].gsub('_','.')
    if params[:servicio] == 'dominio'
      a.nombre_dominio = params[:nombre_dominio]
      a.duracion = '12';
    else
      a.duracion = '1';
    end
    if cuenta_signed_in?
      a.cuenta=current_cuenta
    else
      unless defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
        cookies[:tmp_carrito]={
          :value => BSON::ObjectId.new,
          :expires => 1.year.from_now
        }
      end
      a.tmp_carrito = BSON::ObjectId.from_string(cookies[:tmp_carrito])
    end
    a.save
    redirect_to carrito_path
    # render 'carrito/index.html', :locals => { :articulos => articulos }
  end
  
  def remover
    if cuenta_signed_in?
        articulo = ArticuloCarrito.where('_id' => params[:id], 'cuenta_id' => current_cuenta.id, :borrado.exists => false).first
     elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
        articulo = ArticuloCarrito.where('_id' => params[:id], 'tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false).first
     end
    if articulo
      articulo.borrado = true
      articulo.save
    end
    redirect_to carrito_path
    # render 'carrito/index.html', :locals => { :articulos => articulos }
  end
  
  def alterar
    if(params[:id] && params[:duracion])
      if cuenta_signed_in?
          articulo = ArticuloCarrito.where('_id' => params[:id], 'cuenta_id' => current_cuenta.id, :borrado.exists => false).first
       elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
          articulo = ArticuloCarrito.where('_id' => params[:id], 'tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false).first
       end
       if articulo
         articulo.duracion = params[:duracion]
         articulo.save
       end
    end
    redirect_to carrito_path
  end
  
  def articulos
    if cuenta_signed_in?
       ArticuloCarrito.where('cuenta_id' => current_cuenta.id, :borrado.exists => false)
    elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
       ArticuloCarrito.where('tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false)
    else
      []
    end
  end
  
  def resource_name
    :recarga
  end
  
  def build_resource(hash=nil)
    self.resource = Recarga.new(hash)
  end
  
  def new
    monto = 0
    ArticuloCarrito.where('cuenta_id' => current_cuenta.id, :borrado.exists => false).each do |articulo|
      if articulo[:servicio] == 'hospedaje'
        plan = AppConfig.preferencias.planes_hospedaje.select{|k| k['nombre'] == articulo[:plan] }[0]
        monto = (articulo[:duracion] == 12 ? plan['precio_anual'] : plan['precio_mensual']*articulo[:duracion]) + monto 
      else
        plan = AppConfig.preferencias.planes_dominios.select{|k| k['nombre'] == articulo[:plan] }[0]
        monto = plan['precio_anual'] + monto 
      end
    end
    monto = (AppConfig.preferencias.monedas.select{|k| k['codigo'] == 'vef' }[0]['conversion']*monto).to_s+',00'
    build_resource({:ent_monto => monto, :metodo_pago => 'banco'})
    respond_with self.resource
  end
  
  def create
    build_resource(params[:recarga])
    if resource.save
      respond_with resource, location: root_path do |format|
        format.json {render :json => { _exito: true, _mensaje: 'Pago registrado exitosamente.', _ubicacion: root_path } }
      end
    else
      campos={}
      resource.errors.each do |error|
        campos[error]={_set: {error: resource.errors[error]} }
      end
      respond_with resource do |format|
        format.json {render :json => { _exito: false, _canterrores: resource.errors.count, _campos: campos
          }
        }
      end
    end
  end
  
end