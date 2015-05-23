class Hospedaje::DbUser
  include Mongoid::CumanawsBase
  
  attr_accessor :contrasenia
  
  belongs_to :cuenta
  belongs_to :hospedaje
  
  field :gestor, type: String
  field :usuario, type: String
  
  field :params, type: Hash
    
  before_create :crear
  before_update :actualizar
  
  protected
  
  def crear
    case self.gestor
      when 'mysql'
        db_user = Tercero::Db::MysqlUser.crear(self.usuario,contrasenia)
      when 'pgsql'
        db_user = Tercero::Db::PgsqlUser.crear(self.usuario,contrasenia)
      when 'mongodb'
        db_user = Tercero::Db::MongodbUser.crear(self.usuario,contrasenia)
    end
  end
  
  def cambiar_contrasenia
    case self.gestor
      when 'mysql'
        db_user = Tercero::Db::MysqlUser.cambiar_contrasenia(self.usuario,contrasenia)
      when 'pgsql'
        db_user = Tercero::Db::PgsqlUser.cambiar_contrasenia(self.usuario,contrasenia)
      when 'mongodb'
        db_user = Tercero::Db::MongodbUser.cambiar_contrasenia(self.usuario,contrasenia)
    end
  end
  
end
