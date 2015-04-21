#! /bin/sh
### BEGIN INIT INFO
# Provides:          cumanaws
# Required-Start:    $local_fs $remote_fs $syslog apache2 mongodb
# Required-Stop:     $local_fs $remote_fs $syslog apache2 mongodb
# Should-Start:      pure-ftpd postgresql mysql dovecot postfix
# Should-Stop:       pure-ftpd postgresql mysql dovecot postfix
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: cumanaws
# Description:       cumanaws
### END INIT INFO

. /lib/lsb/init-functions

. /etc/default/cumanaws

if [ $USER != 'root' ]
then
    echo "Debes ejecutar este script como root o sudo."
    exit 1
fi

if [ $ENABLE != true ]
then
    echo "Debes activar cumanaws en el archivo ubicado en /etc/default/cumanaws."
    exit 1
fi

start() {
  log_begin_msg "Iniciando cumanaws"
  if [ ! -e /opt/cumanaws/tmp/pids/daemon.pid ]
  then
    start-stop-daemon -b -m -p /opt/cumanaws/tmp/pids/daemon.pid --start --exec /opt/cumanaws/scripts/rails -- server $APPSERVER -e $ENTORNO -b $BINDING -p $PUERTO
  fi
  log_end_msg 0
}

stop() {
  log_begin_msg "Deteniendo cumanaws"
  if [ -e /opt/cumanaws/tmp/pids/daemon.pid ]
  then
    start-stop-daemon -p /opt/cumanaws/tmp/pids/daemon.pid --stop
  fi
  log_end_msg 0
}

restart() {
  log_begin_msg "Reiniciando cumanaws"
  stop
  start
  log_end_msg 0
}

status() {
  start-stop-daemon -p /opt/cumanaws/tmp/pids/daemon.pid --status
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  status)
    status
    ;;
  *)
    echo "Uso de: $0 {start|stop|restart|status}"
    exit 1
esac