class Cuenta
  # include Mongoid::CumanawsBase
  include Mongoid::Document
  include Humanizer
  
  ## Registro de modificaciones
  embeds_one :creado
  # embeds_many :ediciones

  before_create do |document|
    document.creado = Creado.new
    if $cuenta_signed_in
      document.creado.cuenta = $cuenta
    end
  end

#  before_update do |document|
#    edicion = Edicion.new
#    if $cuenta_signed_in
#      edicion.cuenta = $cuenta
#    end
#    document.ediciones.push(edicion)
#  end
  
#  def self.serialize_from_session(key, salt)
#    record = to_adapter.get(key[0]["$oid"])
#    record if record && record.authenticatable_salt == salt
#  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable , :validatable, :trackable #, :rememberable

  attr_accessor :login, :doc_id_cat, :doc_id, :nombre, :apellidos, :email, :telefono, :entidad_federal, :localidad, :direccion, :terminos
  
  require_human_on :create
  
  field :pais, type: String
  
  belongs_to :persona, autosave: true
  
  ## Database authenticatable
  field :username,            type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  
  #has_one :puntuacion, autosave: true
  
  has_many :organizaciones, autosave: true

  ## Rememberable
  # field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  field :pais, type: String, default: 've'
  field :rol, type: String, default: 'usuario'
  
  field :borrado, type: Boolean
  field :suspendido, type: Boolean
  
  validates_presence_of :username
  validates_length_of :username, minimum: 5, maximum: 20, allow_blank: true
  validates_format_of :username, :with => /\A[A-Za-z0-9_\-.]+\z/i, allow_blank: true, message: 'posee caracteres invalidos'
  validates_uniqueness_of :username
  
  validates_presence_of :doc_id_cat, on: :create
  validates_presence_of :doc_id, on: :create
  validates_presence_of :nombre, on: :create
  validates_presence_of :apellidos, on: :create
  validates_presence_of :email, on: :create
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_presence_of :telefono, on: :create
  validates_presence_of :entidad_federal, on: :create
  validates_presence_of :localidad, on: :create
  validates_presence_of :direccion, on: :create
  
  validates_acceptance_of :terminos, on: :create
  
  #validates_associated :persona
  
  before_create :insertar_persona
  
  # before_update :editar_persona
  
  def email_required?
    false
  end
  
  def email_changed?
    false
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where({:username => /^#{Regexp.escape(login)}$/i}).first
    else
      where(conditions).first
    end
  end 
  
  #accepts_nested_attributes_for :persona, reject_if: :all_blank
  #accepts_nested_attributes_for :organizaciones
  
  protected
    
  def insertar_persona
    
    self.persona=Persona.new
    self.persona.docs_id=[DocId.new(pais: 've', categoria: doc_id_cat, codigo: doc_id)]
    self.persona.nombre=nombre
    self.persona.apellidos=apellidos
    self.persona.emails=[Email.new(email: email)]
    self.persona.telefonos=[Telefono.new(telefono: telefono)]
    self.persona.entidad_federal=entidad_federal
    self.persona.localidad=localidad
    self.persona.direccion=direccion
    
#    self.persona = Persona.buscar_por_docid(doc_id_cat,doc_id)
#    unless self.persona
#      self.persona=Persona.new
#      arr_ciorif = ciorif.to_str.split('-')
#      if arr_ciorif[2]
#        self.persona.ci_o_rif = CiORif.new(categoria: arr_ciorif[0], numero: arr_ciorif[1], extension: arr_ciorif[2])
#      else
#        self.persona.ci_o_rif = CiORif.new(categoria: arr_ciorif[0], numero: arr_ciorif[1])
#      end
#      self.persona.nombre = nombre
#      self.persona.apellidos = apellidos
#    end
#    self.persona.correos = [ Correo.new(correo: correo) ]
#    arr_telefono = telefono.split('-')
#    self.persona.telefonos = [ Telefono.new(codigo: arr_telefono[0], numero: arr_telefono[1]) ]
  end
  
  def editar_persona
    
  end
  
end