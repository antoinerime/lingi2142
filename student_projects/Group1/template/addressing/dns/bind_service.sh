#!/bin/sh -e

### BEGIN INIT INFO
# Provides:          bind9
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Should-Start:      $network $syslog
# Should-Stop:       $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop bind9
# Description:       bind9 is a Domain Name Server (DNS)
#        which translates ip addresses to and from internet names
### END INIT INFO
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# for a chrooted server: "-u bind -t /var/lib/named"
# Don't modify this line, change or create /etc/default/bind9.
OPTIONS=""
RESOLVCONF=no

test -x /usr/sbin/rndc || exit 0

. /lib/lsb/init-functions
PIDFILE=/var/run/named/named_[[node]].pid

check_network() {
    if [ -x /usr/bin/uname ] && [ "X$(/usr/bin/uname -o)" = XSolaris ]; then
	IFCONFIG_OPTS="-au"
    else
	IFCONFIG_OPTS=""
    fi
    if [ -z "$(/sbin/ifconfig $IFCONFIG_OPTS)" ]; then
       #log_action_msg "No networks configured."
       return 1
    fi
    return 0
}

case "$1" in
    "")
	log_daemon_msg "Starting domain name service..." "bind9"

	modprobe capability >/dev/null 2>&1 || true

	# dirs under /var/run can go away on reboots.
	mkdir -p /var/run/named/[[node]]
	chmod 775 /var/run/named/[[node]]
	chown root:bind /var/run/named/[[node]] >/dev/null 2>&1 || true

	if [ ! -x /usr/sbin/named ]; then
	    log_action_msg "named binary missing - not starting"
	    log_end_msg 1
	fi

	if ! check_network; then
	    log_action_msg "no networks configured"
	    log_end_msg 1
	fi

	if start-stop-daemon --start --oknodo --quiet --exec /usr/sbin/named \
		--make-pidfile --pidfile ${PIDFILE} -- $OPTIONS; then
	    if [ "X$RESOLVCONF" != "Xno" ] && [ -x /sbin/resolvconf ] ; then
		echo "nameserver 127.0.0.1" | /sbin/resolvconf -a lo.named
	    fi
	    log_end_msg 0
	else
	    log_end_msg 1
	fi
    ;;

    start)
	log_daemon_msg "Starting domain name service..." "bind9"

	modprobe capability >/dev/null 2>&1 || true

	# dirs under /var/run can go away on reboots.
	mkdir -p /var/run/named/[[node]]
	chmod 775 /var/run/named/[[node]]
	chown root:bind /var/run/named/[[node]] >/dev/null 2>&1 || true

	if [ ! -x /usr/sbin/named ]; then
	    log_action_msg "named binary missing - not starting"
	    log_end_msg 1
	fi

	if ! check_network; then
	    log_action_msg "no networks configured"
	    log_end_msg 1
	fi

	if start-stop-daemon --start --oknodo --quiet --exec /usr/sbin/named \
		--make-pidfile --pidfile ${PIDFILE} -- $OPTIONS; then
	    if [ "X$RESOLVCONF" != "Xno" ] && [ -x /sbin/resolvconf ] ; then
		echo "nameserver 127.0.0.1" | /sbin/resolvconf -a lo.named
	    fi
	    log_end_msg 0
	else
	    log_end_msg 1
	fi
    ;;

    stop)
	log_daemon_msg "Stopping domain name service..." "bind9"
	if ! check_network; then
	    log_action_msg "no networks configured"
	    log_end_msg 1
	fi

	if [ "X$RESOLVCONF" != "Xno" ] && [ -x /sbin/resolvconf ] ; then
	    /sbin/resolvconf -d lo.named
	fi
	pid=$(/usr/sbin/rndc stop -p | awk '/^pid:/ {print $2}') || true
	if [ -z "$pid" ]; then		# no pid found, so either not running, or error
	    pid=$(pgrep -f ^/usr/sbin/named) || true
	    start-stop-daemon --stop --oknodo --quiet --exec /usr/sbin/named \
		    --pidfile ${PIDFILE} -- $OPTIONS
	fi
	if [ -n "$pid" ]; then
	    sig=0
	    n=1
	    while kill -$sig $pid 2>/dev/null; do
		if [ $n -eq 1 ]; then
		    echo "waiting for pid $pid to die"
		fi
		if [ $n -eq 11 ]; then
		    echo "giving up on pid $pid with kill -0; trying -9"
		    sig=9
		fi
		if [ $n -gt 20 ]; then
		    echo "giving up on pid $pid"
		    break
		fi
		n=$(($n+1))
		sleep 1
	    done
	fi
	log_end_msg 0
    ;;

    reload|force-reload)
	log_daemon_msg "Reloading domain name service..." "bind9"
	if ! check_network; then
	    log_action_msg "no networks configured"
	    log_end_msg 1
	fi

	/usr/sbin/rndc reload >/dev/null && log_end_msg 0 || log_end_msg 1
    ;;

    restart)
	if ! check_network; then
	    log_action_msg "no networks configured"
	    exit 1
	fi

	$0 stop
	$0 start
    ;;
    
    status)
    	ret=0
	status_of_proc -p ${PIDFILE} /usr/sbin/named bind9 2>/dev/null || ret=$?
	exit $ret
	;;

    *)
	log_action_msg "Usage: /etc/init.d/bind9 {start|stop|reload|restart|force-reload|status}"
	exit 1
    ;;
esac

