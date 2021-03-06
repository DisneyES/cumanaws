# Manage Zone Files for the Bind9 Internet Domain Name Server
class Tercero::ZoneFile
  include Cumanaws::AppInfo::Dns
  
  # To initialize the class
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param registros [Array<Hash>] Array of subdomains
  # @option registros nombre [String]
  # @option registros registro [String]
  # @option registros direccion [String]
  # @option registros prioridad [String] para registros MX
  def initialize(nombre='',dominio='',registros=[])
    self.actualizar(nombre,dominio,registros)
  end
  
  # To create a new Zone File
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param registros [Array] Array of subdomains
  # @option registros :nombre [String]
  # @option registros :registro [String]
  # @option registros :direccion [String]
  # @option registros :prioridad [String] para registros MX
  def self.crear(nombre,dominio,registros=[])
    self.actualizar(nombre,dominio,registros)
    incluir_en_named(nombre,dominio)
  end
  
  # To update an existing Zone File or create of not exists
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  # @param registros [Array] Array of subdomains
  # @option registros :nombre [String]
  # @option registros :registro [String]
  # @option registros :direccion [String]
  # @option registros :prioridad [String] para registros MX
  def self.actualizar(nombre,dominio,registros=[])
    
    # Abrir el archivo de la zona en la configuración del servidor DNS
    File.open('/var/lib/cumanaws/bind/'+nombre+'.'+dominio+'.zone', 'w') do |zona|
      zona.puts '; '+nombre+'.'+dominio+'
$TTL 3600
'+nombre+'.'+dominio+'.  IN  SOA   '+ns_host+'. '+ns_mail+'. ( 1 3H 1H 1W 1D )
                         IN  NS    '+ns_host+'.
'
      registros.each do |registro|
        zona.puts ''+registro[:nombre]+' '+registro[:registro]+' '+( registro[:registro] == 'MX' ? ( registro[:prioridad] ? registro[:prioridad].to_s  : '10') : '' )+' '+registro[:direccion]
      end
    end
    
    # Reiniciar servidor Bind9
    system("service bind9 restart")
  end
  
  # To include an Zone File in named.conf if not exists already
  # @param nombre [String] Domain Name
  # @param dominio [String] Top Level Domain (TLD)
  def incluir_en_named(nombre,dominio)
    # Agregar la zona a la configuración del servidor Bind9
    File.open('/var/lib/cumanaws/bind/named.conf.cumanaws', 'a') do |named|
      named.puts 'zone "'+nombre+'.'+dominio+'" { type master; file "/var/lib/cumanaws/bind/'+nombre+'.'+dominio+'.zone"; };'
    end
  end
  
end

