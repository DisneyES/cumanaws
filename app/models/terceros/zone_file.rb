# Manage Zone Files for the Bind9 Internet Domain Name Server
class Terceros::ZoneFile
  include Cumanaws::AppInfo::Dns
  
  # To initialize the class
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param subdominios [Array<Hash>] Array of subdomains
  # @option subdominios nombre [String]
  # @option subdominios registro [String]
  # @option subdominios direccion [String]
  # @option subdominios prioridad [String] para registros MX
  def initialize(nombre='',dominio='',subdominios=[])
    self.actualizar(nombre,dominio,subdominios)
  end
  
  # To create a new Zone File
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param subdominios [Array] Array of subdomains
  # @option subdominios :nombre [String]
  # @option subdominios :registro [String]
  # @option subdominios :direccion [String]
  # @option subdominios :prioridad [String] para registros MX
  def self.crear(nombre,dominio,subdominios=[])
    self.actualizar(nombre,dominio,subdominios)
    incluir_en_named(nombre,dominio)
  end
  
  # To update an existing Zone File or create of not exists
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param subdominios [Array] Array of subdomains
  # @option subdominios :nombre [String]
  # @option subdominios :registro [String]
  # @option subdominios :direccion [String]
  # @option subdominios :prioridad [String] para registros MX
  def self.actualizar(nombre,dominio,subdominios=[])
    
    # Abrir el archivo de la zona en la configuración del servidor DNS
    zona = File.open('/etc/bind/zonas/'+nombre+'.'+dominio+'.zone', 'w')
    zona.puts '; '+nombre+'.'+dominio+'
$TTL 3600
'+nombre+'.'+dominio+'.  IN  SOA   '+ns_host+'. '+ns_mail+'. ( '+DateTime.now.strftime("%Y%m%d%H%M%S")+' 3H 1H 1W 1D )
                         IN  NS    '+ns_host+'.
'
    subdominios.each do |subdominio|
      zona.puts ''+subdominio[:nombre]+' '+subdominio[:registro]+' '+( subdominio[:registro] == 'MX' ? ( subdominio[:prioridad] ? subdominio[:prioridad].to_s  : '10') : '' )+' '+subdominio[:direccion]
    end
    zona.close
    
    # Reiniciar servidor Bind9
    system("service bind9 restart")
  end
  
  # To include an Zone File in named.conf if not exists already
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  def incluir_en_named(nombre,dominio)
    # Agregar la zona a la configuración del servidor Bind9
    named = File.open('/etc/bind/named.conf.cumanaws', 'a')
    named.puts 'zone "'+nombre+'.'+dominio+'" { type master; file "/etc/bind/zonas/'+nombre+'.'+dominio+'.zone"; };'
    named.close
  end
  
end

