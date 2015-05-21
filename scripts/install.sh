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
    apt-get -y install apache2 unicorn gunicorn php5 php5-fpm libapache2-mod-fcgid nodejs
    echo "Configurando servidor web"
    if [ ! -e $BASEDIR/config/terceros/apache-vh.conf ]
    then
        cp $BASEDIR/config/terceros/apache-vh.ejemplo.conf $BASEDIR/config/terceros/apache-vh.conf
    fi
    rm -f /etc/apache2/sites-available/cumanaws.conf
    ln -s $BASEDIR/config/terceros/apache-vh.conf /etc/apache2/sites-available/cumanaws.conf
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
    mkdir -p /var/lib/cumanaws/bind/
    touch /var/lib/cumanaws/bind/named.conf.cumanaws
    echo "include \"/var/lib/cumanaws/bind/names.conf.cumanaws\";" >> /etc/bind/named.conf
    service bind9 restart

    echo "Instalando servidor FTP"
    apt-get -y install pure-ftpd-mysql
    echo "Configurando servidor FTP"
    if [ ! -e $BASEDIR/config/terceros/pureftpd-mysql.conf ]
    then
        cp $BASEDIR/config/terceros/pureftpd-mysql.ejemplo.conf $BASEDIR/config/terceros/pureftpd-mysql.conf
    fi
    rm -f /etc/pure-ftpd/db/mysql.conf
    ln -s $BASEDIR/config/terceros/pureftpd-mysql.conf /etc/pure-ftpd/db/mysql.conf
    service pure-ftpd-mysql restart

    echo "Instalando paquetes necesarios para ejecutar cumanaws"
    apt-get -y install bundler libpq-dev libmysqlclient-dev nodejs
    echo "Configurando cumanaws"
    if [ ! -d /etc/cumanaws ]
    then
        mkdir /etc/cumanaws
    fi
    if [ ! -e $BASEDIR/config/cumanaws.yml ]
    then
        cp $BASEDIR/config/cumanaws.ejemplo.yml $BASEDIR/config/cumanaws.yml
    fi
    rm -f /etc/cumanaws/cumanaws.yml
    ln -s $BASEDIR/config/cumanaws.yml /etc/cumanaws/
    if [ ! -e $BASEDIR/config/secrets.yml ]
    then
        cp $BASEDIR/config/secrets.ejemplo.yml $BASEDIR/config/secrets.yml
    fi
    rm -f /etc/cumanaws/secrets.yml
    ln -s $BASEDIR/config/secrets.yml /etc/cumanaws/
    if [ ! -e $BASEDIR/config/mongoid.yml ]
    then
        cp $BASEDIR/config/mongoid.ejemplo.yml $BASEDIR/config/mongoid.yml
    fi
    rm -f /etc/cumanaws/mongoid.yml
    ln -s $BASEDIR/config/mongoid.yml /etc/cumanaws/
    if [ ! -e $BASEDIR/config/database.yml ]
    then
        cp $BASEDIR/config/database.ejemplo.yml $BASEDIR/config/database.yml
    fi
    rm -f /etc/cumanaws/database.yml
    ln -s $BASEDIR/config/database.yml /etc/cumanaws/
    if [ ! -e $BASEDIR/config/default.conf ]
    then
        cp $BASEDIR/config/default.ejemplo.conf $BASEDIR/config/default.conf
    fi
    rm -f /etc/default/cumanaws
    ln -s $BASEDIR/config/default.conf /etc/default/cumanaws
    rm -f /etc/init.d/cumanaws
    ln -s $BASEDIR/scripts/init.sh /etc/init.d/cumanaws
    update-rc.d cumanaws defaults
    systemctl daemon-reload

    cd $BASEDIR
    bundle install
    
    echo "¡listo!"
    echo ""
    echo "AVISO: Recuerda editar los archivos de configuración en el directorio:"
    echo "/etc/cumanaws."
    echo ""
    echo "Crear la base de datos de terceros si se instala por primera vez:"
    echo "# rake db:create"
    echo "# rake db:schema:load"
    echo ""
    echo "Aplicar actualizaciones a la base de datos de terceros:"
    echo "# rake db:migrate"
    echo ""
    echo "Precompilar recursos (CSS, JS, etc):"
    echo "# rake assets:precompile"
}

case `uname -n` in
    debian)
        instalar_en_debian
        ;;
    *)
        echo "No se reconoce este sistema operativo"
        exit 1
esac