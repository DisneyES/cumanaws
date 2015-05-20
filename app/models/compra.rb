class Compra
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  belongs_to :orden_compra
  
  field :tmp_carrito, type: BSON::ObjectId
  
  belongs_to :plan_hospedaje
  belongs_to :plan_dominio
  
  belongs_to :hospedaje
  belongs_to :dominio
  
  field :duracion, type: Integer
  
  field :nombre, type: String   # para adquirir dominios
  
  field :precio, type: Float
  
  field :enviado, type: Boolean
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  field :borrado, type: Boolean
  
  before_update :procesar
  
  protected
  
  def procesar
    
    if self.aceptado
      if self.plan_hospedaje_id
        hospedaje = Hospedaje.new
        hospedaje.nro= Hosedaje.max(:nro).to_i + 1
        hospedaje.cuenta = self.cuenta
        hospedaje.plan_hospedaje = self.plan_hospedaje
        hospedaje.save
      elsif self.plan_dominio_id
        dominio = Dominio.new
        dominio.cuenta = self.cuenta
        dominio.nombre = self.nombre
        dominio.plan_dominio = self.plan_dominio
        dominio.save
      end
    elsif self.rechazado
      
    end
      
  end
  
end