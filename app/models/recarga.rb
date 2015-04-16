class Recarga
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  attr_accessor :ent_cta_bancaria, :ent_monto #, :ent_moneda
  
  field :metodo_pago, type: String, default: 'banco'
  belongs_to :cuenta_bancaria
  belongs_to :moneda
  field :codigo, type: String
  field :monto, type: Float
  field :fecha, type: DateTime
  field :observaciones, type: String
  field :saldo, type: Float
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  
  validates_presence_of :metodo_pago
  # validates_presence_of :ent_moneda
  validates_presence_of :codigo
  validates_presence_of :fecha
  
  validates_presence_of :fecha, with: /\A[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}\z/, allow_blank: true
  
  validates_presence_of :ent_cta_bancaria
  validates_presence_of :ent_monto
  
  validates_format_of :ent_monto, with: /\A([0-9]{1,}\,[0-9]{0,2}|[0-9]{1,})\z/, allow_blank: true
  
  before_create :insertar_datos
  
  after_initialize :para_procesar
  
  before_update :procesar
  
  protected
    
  def insertar_datos
    self.cuenta = $cuenta
    self.monto = ent_monto.gsub(',', '.').to_f
    self.cuenta_bancaria = CuentaBancaria.where(:_id => ent_cta_bancaria).first
    self.moneda = self.cuenta_bancaria.moneda
    self.saldo = self.monto / self.moneda.conversion
    saldo = Saldo.where(:cuenta_id => self.cuenta._id).first
    saldo.espera = saldo.espera + self.saldo
    saldo.save
  end
  
  def para_procesar
    if self.cuenta_bancaria && self.monto
      self.ent_cta_bancaria = self.cuenta_bancaria._id
      self.ent_monto = self.monto.gsub.to_s.gsub('.', ',')
    end
  end
  
  def procesar
    self.monto = ent_monto.gsub(',', '.').to_f
    self.cuenta_bancaria = CuentaBancaria.where(:_id => ent_cta_bancaria).first
    self.saldo = self.monto / self.moneda.conversion
    saldo = Saldo.where(:cuenta_id => self.cuenta._id).first
    fondos = Fondo.where(:moneda => self.moneda).first
    saldo.espera = saldo.espera - self.saldo
    fondos.espera = fondos.espera - self.monto
    if self.aceptado
      saldo.activo = saldo.activo + self.saldo
      fondos.activo = fondos.activo + self.monto
      movimiento_saldo = MovimientoSaldo.new
      movimiento_saldo.cuenta = self.cuenta
      movimiento_saldo.recarga = self
      movimiento_saldo.saldo = self.saldo
      movimiento_saldo.tipo = true
      movimiento_saldo.motivo = 'recarga'
      movimiento_saldo.save
      movimiento_fondo = MovimientoFondo.new
      movimiento_fondo.recarga = self
      movimiento_fondo.tipo = true
      movimiento_fondo.moneda = self.moneda
      movimiento_fondo.monto = self.monto
      movimiento_fondo.motivo = 'recarga'
      movimiento_fondo.save
    end
    saldo.save
    fondos.save
  end
  
end