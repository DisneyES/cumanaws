class Hospedaje::Db
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :hospedaje
  belongs_to :hospedaje_db_user, class_name: 'Hospedaje::DbUser'
  
  field :gestor, type: String
  field :nombre, type: String
  
  field :params, type: Hash
  
  before_create :crear
#  before_update :actualizar
  
  protected
  
  def crear
    case self.gestor
      when 'mysql'
        db = Tercero::Db::Mysql.crear(self.nombre,self.hospedaje._id,self.hospedaje_db_user.usuario)
      when 'pgsql'
        db = Tercero::Db::Pgsql.crear(self.nombre,self.hospedaje._id,self.hospedaje_db_user.usuario)
      when 'mongodb'
        db = Tercero::Db::Mongodb.crear(self.nombre,self.hospedaje._id,self.hospedaje_db_user.usuario)
    end
  end
  
#  def actualizar
#    case self.gestor
#      when 'mysql'
#        db = Tercero::Db::Mysql.actualizar
#      when 'pgsql'
#        db = Tercero::Db::Pgsql.actualizar
#      when 'mongodb'
#        db = Tercero::Db::Mongodb.actualizar
#    end
#  end
  
end
