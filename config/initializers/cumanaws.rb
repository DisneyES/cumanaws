# To verify if everything is all right

# Create zone file for the host of cumanaws if not exists
unless File.exists?('/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone')
  
  zona = File.open('/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone', 'w')
  zona.puts '; '+AppConfig.aplicacion.host+'
  $TTL 3600
  '+AppConfig.aplicacion.host+'.  IN  SOA   '+ns_host+'. '+ns_mail+'. ( '+DateTime.now.strftime("%Y%m%d%H%M%S")+' 3H 1H 1W 1D )
                       IN  NS    '+ns_host+'.
                       IN  A     '+AppConfig.aplicacion.ns.ip+'
  www                  IN  A     '+AppConfig.aplicacion.ns.ip+'
  ns                   IN  A     '+AppConfig.aplicacion.ns.ip+'
  '
  zona.close
  
  named = File.open('/var/lib/cumanaws/bind/named.conf.cumanaws', 'a')
  named.puts 'zone "'+AppConfig.aplicacion.host+'" { type master; file "/var/lib/cumanaws/bind/'+AppConfig.aplicacion.host+'.zone"; };'
  named.close
  
  # Reiniciar servidor Bind9
  system("service bind9 restart")
  
end