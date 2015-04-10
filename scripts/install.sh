 #!/bin/sh

# Script para instalar cumanaws junto a los servicios que administra.

if [ $USER != 'root' ]
then
    echo "Debes ejecutar este script como root o sudo."
    exit 1
fi

SCRIPT=$(readlink -f "$0")
#SCRIPTDIR=$(dirname "$SCRIPT")
BASEDIR=${SCRIPT/%\/scripts\/install.sh/}

instalar_en_debian(){
    echo "Preparando la instalación de cumanaws en Debian"

    echo "Actualizando los repositorios"
    apt-get update

    echo "Instalando servicios que administra cumanaws."
    
    echo "Instalando servidor web y servidores de aplicaciones"
    apt-get -y install apache2 unicorn gunicorn php5-fpm libapache2-mod-fcgid nodejs
    echo "Configurando servidor web"
    cp $BASEDIR/config/apache-vh.ejemplo.conf $BASEDIR/config/apache-vh.conf
    ln -s $BASEDIR/config/apache-vh.conf /etc/apache2/sites-available/cumanaws.conf
    a2ensite cumanaws
    a2enmod ssl
    a2enmod rewrite
    a2enmod headers
    a2enmod proxy
    a2enmod proxy_http
    a2enmod proxy_balancer
    a2enmod lbmethod_byrequests
    service apache2 restart

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
    apt-get -y install pure-ftpd-mysql
    echo "Configurando servidor FTP"
    
    echo "Instalando paquetes necesarios para ejecutar cumanaws"
    apt-get -y install bundler libpq-dev libmysqlclient-dev nodejs
    echo "Configurando cumanaws"
    mkdir /etc/cumanaws
    cp $BASEDIR/config/mongoid.ejemplo.yml $BASEDIR/config/mongoid.yml
    cp $BASEDIR/config/cumanaws.ejemplo.yml $BASEDIR/config/cumanaws.yml
    ln -s $BASEDIR/config/cumanaws.yml /etc/cumanaws/
    ln -s $BASEDIR/config/mongoid.yml /etc/cumanaws/
    
    ln -s $BASEDIR/scripts/init.sh /etc/init.d/cumanaws
    update-rc.d cumanaws defaults
    systemctl daemon-reload

    cd $BASEDIR
    bundle install
    
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