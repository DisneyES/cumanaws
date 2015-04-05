class Dominio
  include Mongoid::CumanawsBase
  
  belongs_to :cuenta
  belongs_to :plan_dominio
  
  field :nombre, type: String
  
  before_create :activar_servicio
  
  protected
  
  def activar_servicio
    # Crear el archivo de la zona en la configuración del servidor DNS
    zona = File.open('/etc/bind/zonas/'+self.nombre+'.'+self.plan_dominio[:dominio]+'.zone', 'w')
    zona.puts '; '+self.nombre+'.'+self.plan_dominio[:dominio]+'
$TTL 3600
'+self.nombre+'.'+self.plan_dominio[:dominio]+'.  IN  SOA   ns.cumanaws.net.ve. dns@cumanaws.net.ve. ( '+DateTime.now.strftime("%Y%m%d%H%M%S")+' 3H 1H 1W 1D )
                                                  IN  NS    ns.cumanaws.net.ve.
'+self.nombre+'.'+self.plan_dominio[:dominio]+'.  IN  A     cumanaws.net.ve
; www                                               IN  CNAME '+self.nombre+'.'+self.plan_dominio[:dominio]+'.'
    zona.close
    
    # Agregar la zona a la configuración del servidor DNS
    named = File.open('/etc/bind/named.conf.zonas', 'a')
    named.puts 'zone "'+self.nombre+'.'+self.plan_dominio[:dominio]+'" { type master; file "/etc/bind/zonas/'+self.nombre+'.'+self.plan_dominio[:dominio]+'.zone"; };'
    named.close
    
    # Reiniciar servidor DNS
    
  end
  
end