#!/bin/sh -
#
# Copyright (c) 1984, 1986, 1990, 1993
#	The Regents of the University of California.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#	This product includes software developed by the University of
#	California, Berkeley and its contributors.
# 4. Neither the name of the University nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#	@(#)newvers.sh	8.1 (Berkeley) 4/20/94
# newvers.sh,v 1.16 1995/05/02 22:20:03 phk Exp

TYPE="FreeBSD"
RELEASE=2.0.5-RELEASE
RELDATE="199504"

if [ "x$RELEASE" = x2.0-CURRENT ] ; then
	RELEASE=`date '+2.0-BUILT-%Y%m%d'`
fi

DISTNAME=${RELEASE}

if [ "x$JUST_TELL_ME" = "x" ]
then
	if [ ! -r version ]
	then
		echo 0 > version
	fi

	touch version
	v=`cat version` u=${USER-root} d=`pwd` h=`hostname` t=`date`
	echo "char ostype[] = \"${TYPE}\";" > vers.c
	echo "char osrelease[] = \"${RELEASE}\";" >> vers.c
	echo "int osreldate = ${RELDATE};" >> vers.c
	echo "char sccs[4] = { '@', '(', '#', ')' };" >>vers.c
	echo "char version[] = \"${TYPE} ${RELEASE} #${v}: ${t}\\n    ${u}@${h}:${d}\\n\";" >>vers.c

	echo `expr ${v} + 1` > version
fi
