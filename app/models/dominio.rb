class Dominio
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_dominio
  
  field :nombre, type: String
  
  has_many :subdominios
  
  before_create :crear_zona
  before_update :editar_zona
  before_update :editar_zona
  
  protected
  
  def crear_zona
    # Crear el archivo de la zona en la configuración del servidor DNS
    zona = File.open('/etc/bind/zonas/'+self.nombre+'.'+self.plan_dominio[:dominio]+'.zone', 'w')
    zona.puts '; '+self.nombre+'.'+self.plan_dominio[:dominio]+'
$TTL 3600
'+self.nombre+'.'+self.plan_dominio[:dominio]+'.  IN  SOA   '+ns_host+'. '+ns_mail+'. ( '+DateTime.now.strftime("%Y%m%d%H%M%S")+' 3H 1H 1W 1D )
                                                  IN  NS    '+ns_host+'.
'+self.nombre+'.'+self.plan_dominio[:dominio]+'.  IN  CNAME '+app_host+'.'
    zona.close
    
    # Agregar la zona a la configuración del servidor DNS
    named = File.open('/etc/bind/named.conf.cumanaws', 'a')
    named.puts 'zone "'+self.nombre+'.'+self.plan_dominio[:dominio]+'" { type master; file "/etc/bind/zonas/'+self.nombre+'.'+self.plan_dominio[:dominio]+'.zone"; };'
    named.close
    
    # Reiniciar servidor DNS
    # service bind9 restart
    system("service bind9 restart")
    
  end
  
  def editar_zona
    
  end
  
end