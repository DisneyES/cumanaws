class Creado
  include Mongoid::Document
  
  embedded_in :cuenta
  embedded_in :persona
  embedded_in :rol
  
  field :fecha, type: DateTime, default: DateTime.now
  field :ip, type: String, default: $remote_ip
  belongs_to :cuenta, autosave: true
  
  #index({ fecha: 1, ip: 1 }, { unique: false })
  
end
