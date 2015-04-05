 #!/bin/sh

# Script para instalar cumanaws junto a los servicios que administra.

instalar_en_debian(){
    echo "Instalando cumanaws en Debian"
    
    apt-get update
    
    echo "Instalando paquetes necesarios para ejecutar cumanaws"
    apt-get -y install bundler libpq-dev libmysqlclient-dev nodejs mongodb
    
    echo "Instalando servidor web y servidores de aplicaciones"
    apt-get -y install apache2 unicorn php5-fpm nodejs
    echo "Configurando servidor web"
    
    echo "Instalando servidores de bases de datos"
    apt-get -y install mysql-server postgresql sqlite3 mongodb
    echo "Configuracion servidores de bases de datos"

    echo "Instalando servidor de correo electrónico"
    apt-get -y install postfix dovecot-core dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-antispam
    echo "Configurando servidor de correo electrónico"

    echo "Instalando servidor DNS"
    apt-get -y install bind9
    echo "Configurando servidor DNS"

    echo "Instalando servidor FTP"
    apt-get -y install pure-ftpd
    echo "Configurando servidor FTP"
    
}

case `uname -n` in
    debian)
        instalar_en_debian
        ;;
    *)
        echo "No se reconoce este sistema operativo"
        exit 1
esac