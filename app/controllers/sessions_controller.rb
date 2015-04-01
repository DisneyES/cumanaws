class SessionsController < Devise::SessionsController
  
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    if params[:redir]
      @path = '/iniciarsesion/'+params[:redir]
    else
      @path = '/iniciarsesion'
    end
    respond_with(resource, serialize_options(resource))
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    if defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
      articulos = ArticuloCarrito.where('tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false)
      articulos.each do |articulo|
        articulo.cuenta = current_cuenta
        articulo.tmp_carrito = nil
        articulo.save
      end
      cookies.delete :tmp_carrito
    end
    
    if params[:redir]
      locacion = '/'+params[:redir]
    else
      locacion = after_sign_in_path_for(resource)
    end
    yield resource if block_given?
    respond_with resource, location: locacion
  end
  
end