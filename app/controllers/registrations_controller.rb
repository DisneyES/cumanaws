class RegistrationsController < Devise::RegistrationsController
  
  def new
    build_resource({})
    respond_with self.resource
  end
  
  def create
    build_resource(sign_up_params)
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        if defined?(cookies[:tmp_carrito]) && BSON::ObjectId.legal?(cookies[:tmp_carrito])
          articulos = ArticuloCarrito.where('tmp_carrito' => cookies[:tmp_carrito], :borrado.exists => false)
          articulos.each do |articulo|
            articulo.cuenta = current_cuenta
            articulo.tmp_carrito = nil
            articulo.save
          end
          cookies.delete :tmp_carrito
        end
        respond_with resource, location: after_sign_up_path_for(resource) do |format|
          format.json {render :json => { _exito: true, _mensaje: 'Cuenta creada exitosamente.', _ubicacion: root_path } }
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource) do |format|
          format.json {render :json => { _exito: true, _mensaje: 'Cuenta creada exitosamente.' } }
        end
      end
    else
      clean_up_passwords resource
      resource.change_humanizer_question(sign_up_params[:humanizer_question_id])
      campos={ :humanizer_answer => { _set: {  } } }
      resource.errors.each do |error|
        campos[error]={_set: {error: resource.errors[error]} }
      end
      resource.change_humanizer_question(sign_up_params[:humanizer_question_id])
      campos[:humanizer_answer][:_set][:label] = resource.humanizer_question
      campos[:humanizer_answer][:_set][:value] = ''
      campos[:humanizer_question_id]= { :_set => {:value => resource.humanizer_question_id } }
      respond_with resource do |format|
        format.json {render :json => { _exito: false, _canterrores: resource.errors.count, _campos: campos
          }
        }
      end
    end
  end
  
#  def edit
#    
#  end
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
#    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
#      yield resource if block_given?
#      if is_flashing_format?
#        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
#          :update_needs_confirmation : :updated
#        set_flash_message :notice, flash_key
#      end
      sign_in resource_name, resource, bypass: true
#      respond_with resource, location: after_update_path_for(resource)
      respond_with resource, location: after_update_path_for(resource) do |format|
          format.json {render :json => { _exito: true, _mensaje: 'Cuenta editada exitosamente.', _ubicacion: root_path } }
        end
    else
      clean_up_passwords resource
      campos={}
      resource.errors.each do |error|
        campos[error]={_set: {error: resource.errors[error]} }
      end
      respond_with resource do |format|
        format.json {render :json => { _exito: false, _canterrores: resource.errors.count, _campos: campos} }
      end
    end
  end
  
  def validar_pais
    unless AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0].nil? ||
        AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0]['entidades_federales'].nil?
      opciones={ 'Seleccione'=>'' }
      AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0]['entidades_federales'].each do |ef|
        opciones.store(ef['nombre'], ef['codigo'])
      end
      arr={
        _campos: {
          entidad_federal: { _set: { opciones: opciones } }
        }
      }
    else
      arr={
        _campos: {
          entidad_federal: { _unset: { opciones: 1 } }
        }
      }
    end
    render :json => arr
  end
  
  def validar_ef
    unless AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0]['entidades_federales'].select{|k| k['codigo']==params[:ef]}[0].nil? ||
        AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0]['entidades_federales'].select{|k| k['codigo']==params[:ef]}[0]['localidades'].nil?
      opciones={ 'Seleccione'=>'' }
      AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==params[:pais]}[0]['entidades_federales'].select{|k| k['codigo']==params[:ef]}[0]['localidades'].each do |localidad|
        opciones.store(localidad['nombre'], localidad['codigo'])
      end
      arr={
        _campos: {
          localidad: { _set: { opciones: opciones } }
        }
      }
    else
      arr={
        _campos: {
          localidad: { _unset: { opciones: 1 } }
        }
      }
    end
    render :json => arr
  end
  
#  def validar_organizacion
#    if params['representa']
#      arr={
#        _campos: {
#          organizacion_attributes_tipo: { _unset: {disabled: 1 } },
#          organizacion_attributes_doc_ids_attributes_doc_id: { _unset: {disabled: 1 } },
#          organizacion_attributes_nombre: { _unset: {disabled: 1 } },
#          organizacion_attributes_emails_attributes_email: { _unset: {disabled: 1 } },
#          organizacion_attributes_telefonos_attributes_telefono: { _unset: {disabled: 1 } },
#          organizacion_attributes_entidad_federal: { _unset: {disabled: 1 } },
#          organizacion_attributes_localidad: { _unset: {disabled: 1 } },
#          organizacion_attributes_direccion: { _unset: {disabled: 1 } },
#        }
#      }
#    else
#      arr={
#        _campos: {
#          organizacion_attributes_tipo: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_doc_ids_attributes_doc_id: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_nombre: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_emails_attributes_email: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_telefonos_attributes_telefono: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_entidad_federal: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_localidad: { _set: {disabled: 1, value: '' } },
#          organizacion_attributes_direccion: { _set: {disabled: 1, value: '' } },
#        }
#      }
#    end
#    render :json => arr
#  end
#  
#  def validar_organizacion_ef
#    unless AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']=='ve'}[0]['entidades_federales'].select{|k| k['codigo']==params[:ef]}[0]['localidades'].nil?
#      opciones={ 'Seleccione'=>'00' }
#      AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']=='ve'}[0]['entidades_federales'].select{|k| k['codigo']==params[:ef]}[0]['localidades'].each do |localidad|
#        opciones.store(localidad['nombre'], localidad['codigo'])
#      end
#      arr={
#        _campos: {
#          organizacion_attributes_localidad: { _set: { opciones: opciones } }
#        }
#      }
#    else
#      arr={
#        _campos: {
#          organizacion_attributes_localidad: { _unset: { opciones: 1 } }
#        }
#      }
#    end
#    render :json => arr
#  end
  
end