class MiCuenta::Dominios::RegistrosController
  
  before_action :authenticate_cuenta!

  def resource_name
    :subdominio
  end
  
  def new
    self.resource = Dominio::Registro.new
  end
  
  def create
    self.resource = Dominio::Registro.new(params[:subdominio])
  end
  
  def edit
    self.resource = Dominio::Registro.where(:_id => params[:id]).first
  end
  
  def update
    self.resource = Dominio::Registro.where(:_id => params[:id]).first
  end
  
end
