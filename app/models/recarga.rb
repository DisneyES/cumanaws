class Recarga
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  
  attr_accessor :ent_cta_bancaria, :ent_monto
  
  field :metodo_pago, type: String
  belongs_to :cuenta_bancaria, autosave: true
  field :moneda, type: String, default: 'vef'
  field :codigo, type: String
  field :monto, type: Float
  field :fecha, type: DateTime
  field :observaciones, type: String
  field :puntos, type: Integer
  field :aceptado, type: Boolean
  field :rechazado, type: Boolean
  
  validates_presence_of :metodo_pago
  validates_presence_of :moneda
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
    self.monto = ent_monto.gsub(',', '.').to_f
    self.puntos = (self.monto / AppConfig.preferencias.monedas.select{|k| k['codigo'] == moneda }[0]['conversion']).ceil
    if self.metodo_pago == 'banco'
      self.cuenta_bancaria = CuentaBancaria.where(:nro => ent_cta_bancaria).first
    end
  end
  
  def para_procesar
    if self.cuenta_bancaria && self.monto
      self.ent_cta_bancaria = self.cuenta_bancaria.nro
      self.ent_monto = self.monto.gsub.to_s.gsub('.', ',')
    end
  end
  
  def procesar
    self.monto = ent_monto.gsub(',', '.').to_f
    self.puntos = (self.monto / AppConfig.preferencias.monedas.select{|k| k['codigo'] == moneda }[0]['conversion']).ceil
    if self.metodo_pago == 'banco'
      self.cuenta_bancaria = CuentaBancaria.where(:nro => ent_cta_bancaria).first
    end
    puntaje = Puntaje.where(:cuenta_id => self.cuenta._id).first
    fondos = Fondo.where(:moneda => self.moneda).first
    puntaje.espera = puntaje.espera - self.puntos
    fondos.espera = fondos.espera - self.monto
    if self.aceptado
      puntaje.activo = puntaje.activo + self.puntos
      fondos.activo = fondos.activo + self.monto
      movimiento_puntaje = MovimientoPuntaje.new
      movimiento_puntaje.cuenta = self.cuenta
      movimiento_puntaje.recarga = self
      movimiento_puntaje.puntos = self.puntos
      movimiento_puntaje.tipo = true
      movimiento_puntaje.motivo = 'recarga'
      movimiento_puntaje.save
      movimiento_fondo = MovimientoFondo.new
      movimiento_fondo.recarga = self
      movimiento_fondo.tipo = true
      movimiento_fondo.monto = self.monto
      movimiento_fondo.motivo = 'recarga'
      movimiento_fondo.save
    end
    puntaje.save
    fondos.save
  end
  
end