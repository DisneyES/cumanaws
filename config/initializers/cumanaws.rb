# To verify if everything is all right

# Create zone file for the host of cumanaws if not exists
unless File.exists?('/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone')
  
  File.open('/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone', 'w') do |zona|
    zona.puts '; '+AppConfig.aplicacion.host+'
$TTL 3600
'+AppConfig.aplicacion.host+'.  IN  SOA   '+AppConfig.aplicacion.ns.host+'. '+AppConfig.aplicacion.ns.mail+'. ( 0 3H 1H 1W 1D )
                     IN  NS    '+AppConfig.aplicacion.ns.host+'.
                     IN  A     '+AppConfig.aplicacion.ns.ip+'
www                  IN  A     '+AppConfig.aplicacion.ns.ip+'
ns                   IN  A     '+AppConfig.aplicacion.ns.ip+'
    '
  end
  
  File.open('/var/lib/cumanaws/bind/named.conf.cumanaws', 'a') do |named|
    named.puts 'zone "'+AppConfig.aplicacion.host+'" { type master; file "/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone"; };'
  end
  
  # Reiniciar servidor Bind9
  system("service bind9 restart")
  
end