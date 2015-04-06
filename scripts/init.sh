 #!/bin/sh -e
### BEGIN INIT INFO
# Provides:          cumanaws
# Required-Start:    $local_fs $remote_fs $syslog apache2 mongodb
# Required-Stop:     $local_fs $remote_fs $syslog apache2 mongodb
# Should-Start:      quota slapd pure-ftpd postgresql mysql dovecot postfix
# Should-Stop:       quota slapd pure-ftpd postgresql mysql dovecot postfix
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: cumanaws
# Description:       cumanaws
### END INIT INFO

. /lib/lsb/init-functions

start() {
  log_begin_msg "Iniciando cumanaws"
  /opt/cumanaws/scripts/rails server -d
  log_end_msg 0
}

stop() {
  log_begin_msg "Deteniendo cumanaws"
  start-stop-daemon -p /opt/cumanaws/tmp/pids/server.pid --stop
  log_end_msg 0
}

restart() {
  log_begin_msg "Reiniciando cumanaws"
  stop
  start
  log_end_msg 0
}

status() {
  start-stop-daemon -p /opt/cumanaws/tmp/pids/server.pid --status
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