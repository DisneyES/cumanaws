class CuentaBancaria
  include Mongoid::CumanawsBase
  
  attr_accessor :ent_banco
  
  belongs_to :banco, autosave: true
  belongs_to :moneda
  field :nro, type: String
  field :tipo, type: String
  field :titular, type: String
  field :borrado, type: Boolean
  
  before_save :insertar_datos
  
  after_initialize :para_editar
  
  protected
  
  def insertar_datos
    self.banco = Banco.where( :nombre => ent_banco ).first
    unless self.banco
      self.banco = Banco.new( :nombre => ent_banco )
    end
  end
  
  def para_editar
    if self.banco
      self.ent_banco = self.banco.nombre
    end
  end
  
end