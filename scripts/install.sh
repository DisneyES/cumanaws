 #!/bin/sh

# Script para instalar cumanaws junto a los servicios que administra.

if [ $USER != 'root' ]
then
    echo "Debes ejecutar este script como root o sudo."
    exit 1
end

instalar_en_debian(){
    echo "Instalando cumanaws en Debian"

    apt-get update

    echo "Instalando servicios que administra cumanaws."
    
    echo "Instalando servidor web y servidores de aplicaciones"
    apt-get -y install apache2 unicorn gunicorn php5-fpm libapache2-mod-fastcgi nodejs
    echo "Configurando servidor web"
    cp /opt/cumanaws/config/apache-vh.ejemplo.conf /opt/cumanaws/config/apache-vh.conf
    ln -s /opt/cumanaws/config/apache-vh.conf /etc/apache2/sites-available/cumanaws.conf
    a2ensite cumanaws
    service apache2 reload

    echo "Instalando servidores de bases de datos"
    apt-get -y install mysql-server postgresql sqlite3 mongodb
    echo "Configuracion servidores de bases de datos"

    echo "Instalando servidor de correo electrónico"
    apt-get -y install postfix postfix-mysql dovecot-core dovecot-mysql dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-antispam
    echo "Configurando servidor de correo electrónico"

    echo "Instalando servidor DNS"
    apt-get -y install bind9
    echo "Configurando servidor DNS"
    mkdir /etc/bind/zonas
    touch /etc/bind/named.conf.cumanaws
    echo "include \"/etc/bind/names.conf.cumanaws\";" >> /etc/bind/named.conf

    echo "Instalando servidor FTP"
    apt-get -y install pure-ftpd pure-ftpd-mysql
    echo "Configurando servidor FTP"
    
    echo "Instalando paquetes necesarios para ejecutar cumanaws"
    apt-get -y install bundler libpq-dev libmysqlclient-dev nodejs
    echo "Configurando cumanaws"
    mkdir /etc/cumanaws
    cp /opt/cumanaws/config/mongoid.ejemplo.yml /opt/cumanaws/config/mongoid.yml
    cp /opt/cumanaws/config/pordefecto.ejemplo.yml /opt/cumanaws/config/pordefecto.yml
    ln -s /opt/cumanaws/config/pordefecto.yml /etc/cumanaws/
    ln -s /opt/cumanaws/config/mongoid.yml /etc/cumanaws/
    
    ln -s /opt/cumanaws/scripts/init.sh /etc/init.d/cumanaws
    update-rc.d cumanaws defaults
    
    echo "¡listo!"
}

case `uname -n` in
    debian)
        instalar_en_debian
        ;;
    *)
        echo "No se reconoce este sistema operativo"
        exit 1
esac