 # To get information about the rols
module RolInfo

  # Return the name of the rol for the current user, or false if the user is not signed in
  # @return [String,Boolean]
  def current_cuenta_rol
    if cuenta_signed_in?
      current_cuenta.rol
    end
    false
  end
  
  # Return true if the rol for the current user is "administrador"
  # @return [Boolean,nil]
  def autenticar_rol_administrador!
    if cuenta_signed_in? && current_cuenta.rol == 'administrador'
      true
    else
      redirect_to root_path
    end
  end
  
  # Return true if the rol for the current user is "usuario"
  # @return [Boolean,nil]
  def autenticar_rol_usuario!
    if cuenta_signed_in? && current_cuenta.rol == 'usuario'
      true
    else
      redirect_to root_path
    end
  end
  
end
