#!/bin/sh -
#
#	from named.restart	5.4 (Berkeley) 6/27/89
#	named.restart.sh,v 1.3 1995/05/03 03:26:59 rgrimes Exp
#

# If there is a global system configuration file, suck it in.
if [ -f /etc/sysconfig ]; then
	. /etc/sysconfig
fi

PATH=%DESTSBIN%:/bin:/usr/bin

if [ -f %PIDDIR%/named.pid ]; then
	pid=`cat %PIDDIR%/named.pid`
	kill $pid
	sleep 5
fi

# $namedflags is imported from /etc/sysconfig
if [ "X${namedflags}" != "XNO" ]; then 
	exec %INDOT%named ${namedflags}
fi
