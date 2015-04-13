class CarritoController < ApplicationController
  
  def index
    render :locals => { :articulos => articulos }
  end
  
  def agregar_dominio
    if params[:id] && params[:nombre]
      plan_dominio = PlanDominio.where(:_id => params[:id], :borrado => {'$exists' => false}).first
      if plan_dominio
        compra = Compra.new
        if cuenta_signed_in?
          compra.cuenta=current_cuenta
        else
          unless defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
            cookies[:tmp_carrito]={
              :value => BSON::ObjectId.new,
              :expires => 1.year.from_now
            }
          end
          compra.tmp_carrito = BSON::ObjectId.from_string(cookies[:tmp_carrito])
        end
        compra.plan_dominio = plan_dominio
        compra.nombre = params[:nombre]
        compra.duracion = 12
        compra.precio = plan_dominio.precio_anual
        compra.save
      end
    end
    redirect_to carrito_path
  end
  
  def agregar_hospedaje
    if params[:id]
      plan_hospedaje = PlanHospedaje.where(:_id => params[:id], :borrado => {'$exists' => false}).first
      if plan_hospedaje
        compra = Compra.new
        if cuenta_signed_in?
          compra.cuenta=current_cuenta
        else
          unless defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
            cookies[:tmp_carrito]={
              :value => BSON::ObjectId.new,
              :expires => 1.year.from_now
            }
          end
          compra.tmp_carrito = BSON::ObjectId.from_string(cookies[:tmp_carrito])
        end
        compra.plan_hospedaje = plan_hospedaje
        compra.duracion = 1
        compra.precio = plan_hospedaje.precio_mensual
        compra.save
      end
    end
    redirect_to carrito_path
  end
  
  def remover
    if cuenta_signed_in?
        articulo = Compra.where('_id' => params[:id], 'cuenta_id' => current_cuenta.id, :borrado.exists => false).first
     elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
        articulo = Compra.where('_id' => params[:id], 'tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false).first
     end
    if articulo
      articulo.borrado = true
      articulo.save
    end
    redirect_to carrito_path
    # render 'carrito/index.html', :locals => { :articulos => articulos }
  end
  
  def editar
    if(params[:id] && params[:duracion])
      if cuenta_signed_in?
        articulo = Compra.where('_id' => params[:id], 'cuenta_id' => current_cuenta.id, :borrado.exists => false).first
      elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
        articulo = Compra.where('_id' => params[:id], 'tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false).first
      end
      if articulo
        if articulo.plan_dominio
          articulo.duracion = 12
          articulo.precio = articulo.plan_dominio.precio_anual
        elsif articulo.plan_hospedaje
          articulo.duracion = ( params[:duracion] == '12' ? 12 : ( params[:duracion] == '6' ? 6 : params[:duracion] == '3' ? 3 : 1 ) )
          articulo.precio = ( params[:duracion] == '12' ? articulo.plan_hospedaje.precio_anual : ( params[:duracion] == '6' ? articulo.plan_hospedaje.precio_mensual*6 : params[:duracion] == '3' ? articulo.plan_hospedaje.precio_mensual*3 : articulo.plan_hospedaje.precio_mensual ) )
        end
        articulo.save
      end
    end
    redirect_to carrito_path
  end
  
  def articulos
    if cuenta_signed_in?
      compras = Compra.where('cuenta_id' => current_cuenta.id, :borrado.exists => false)
    elsif defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
      compras = Compra.where('tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false)
    else
      compras = []
    end
    articulos = []
    compras.each do |compra|
      articulo = {:_id => compra._id}
      if compra.plan_dominio
        articulo[:servicio] = 'dominio'
        articulo[:dominio] = compra.plan_dominio.dominio
        articulo[:nombre] = compra.nombre
      elsif compra.plan_hospedaje
        articulo[:servicio] = 'hospedaje'
        articulo[:plan] = compra.plan_hospedaje.nombre
        articulo[:espacio] = compra.plan_hospedaje.espacio
      end
      articulo[:duracion] = compra.duracion
      articulo[:precio] = compra.precio
      articulos.push(articulo)
    end
    return articulos
  end
  
  def resource_name
    :recarga
  end
  
  def build_resource(hash=nil)
    self.resource = Recarga.new(hash)
  end
  
  def new
    monto = 0
    Compra.where('cuenta_id' => current_cuenta.id, :borrado.exists => false).each do |articulo|
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