class Recarga
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta, default: $cuenta
  
  attr_accessor :ent_cta_bancaria, :ent_monto
  
  field :metodo_pago, type: String
  belongs_to :cuenta_bancaria, autosave: true
  field :moneda, type: String, default: 'vef'
  field :codigo, type: String
  field :monto, type: Float
  field :fecha, type: DateTime
  field :observaciones, type: String
  field :puntos, type: Integer
  field :estado, type: Integer
  
  validates_presence_of :metodo_pago
  validates_presence_of :moneda
  validates_presence_of :codigo
  validates_presence_of :fecha
  
  validates_presence_of :fecha, with: /\A[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}\z/, allow_blank: true
  
  validates_presence_of :ent_cta_bancaria
  validates_presence_of :ent_monto
  
  validates_format_of :ent_monto, with: /\A([0-9]{1,}\,[0-9]{0,2}|[0-9]{1,})\z/, allow_blank: true
  
  before_create :insertar_datos
  
  protected
    
  def insertar_datos
    self.monto = ent_monto.gsub(',', '.').to_f
    self.puntos = (self.monto / AppConfig.preferencias.monedas.select{|k| k['codigo'] == moneda }[0]['conversion']).ceil
    
#    unless self.cuenta_bancaria = CuentaBancaria.where(:nro => ent_cuenta_bancaria).first
#      self.cuenta_bancaria = CuentaBancaria.new
#      cta = AppConfig.preferencias.metodos_pago.select{|k| k['tipo'] == 'banco' }[0]['cuentas'].select{|k| k['nro'] == ent_cuenta_bancaria}[0]
#      self.cuenta_bancaria.empresa = cta['empresa']
#      self.cuenta_bancaria.nro = cta['nro']
#      self.cuenta_bancaria.tipo = cta['tipo']
#      self.cuenta_bancaria.titular = cta['titular']
#      self.cuenta_bancaria.monedas = cta['monedas']
#    end
    
    
  end
  
end