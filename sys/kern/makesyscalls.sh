#! /bin/sh -
#	@(#)makesyscalls.sh	8.1 (Berkeley) 6/10/93
# makesyscalls.sh,v 1.12 1995/03/16 18:12:39 bde Exp

set -e

# name of compat option:
compat=COMPAT_43

# output files:
sysnames="syscalls.c"
syshdr="../sys/syscall.h"
syssw="init_sysent.c"
syshide="../sys/syscall-hide.h"

# tmp files:
sysdcl="sysent.dcl"
syscompat="sysent.compat"
sysent="sysent.switch"

trap "rm $sysdcl $syscompat $sysent" 0

case $# in
    0)	echo "Usage: $0 input-file" 1>&2
	exit 1
	;;
esac

awk < $1 "
	BEGIN {
		sysdcl = \"$sysdcl\"
		syscompat = \"$syscompat\"
		sysent = \"$sysent\"
		sysnames = \"$sysnames\"
		syshdr = \"$syshdr\"
		compat = \"$compat\"
		syshide = \"$syshide\"
		infile = \"$1\"
		"'

		printf "/*\n * System call switch table.\n *\n" > sysdcl
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysdcl

		printf "\n#ifdef %s\n", compat > syscompat
		printf "#define compat(n, name) n, __CONCAT(o,name)\n\n" > syscompat

		printf "/*\n * System call names.\n *\n" > sysnames
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysnames

		printf "/*\n * System call numbers.\n *\n" > syshdr
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > syshdr
		printf "/*\n * System call hiders.\n *\n" > syshide
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > syshide
	}
	NR == 1 {
		printf " * created from%s\n */\n\n", $0 > sysdcl
		printf "#include <sys/param.h>\n" > sysdcl
		printf "#include <sys/sysent.h>\n\n" > sysdcl

		printf "struct sysent sysent[] = {\n" > sysent

		printf " * created from%s\n */\n\n", $0 > sysnames
		printf "char *syscallnames[] = {\n" > sysnames

		printf " * created from%s\n */\n\n", $0 > syshdr

		printf " * created from%s\n */\n\n", $0 > syshide
		next
	}
	NF == 0 || $1 ~ /^;/ {
		next
	}
	$1 ~ /^#[ 	]*if/ {
		print > sysent
		print > sysdcl
		print > syscompat
		print > sysnames
		print > syshide
		savesyscall = syscall
		next
	}
	$1 ~ /^#[ 	]*else/ {
		print > sysent
		print > sysdcl
		print > syscompat
		print > sysnames
		print > syshide
		syscall = savesyscall
		next
	}
	$1 ~ /^#/ {
		print > sysent
		print > sysdcl
		print > syscompat
		print > sysnames
		print > syshide
		next
	}
	syscall != $1 {
		printf "%s: line %d: syscall number out of sync at %d\n", \
		   infile, NR, syscall
		printf "line is:\n"
		print
		exit 1
	}
	{	comment = $5
		for (i = 6; i <= NF; i++)
			comment = comment " " $i
		if (NF < 6)
			$6 = $5
		if ($4 != "NOHIDE")
			printf("HIDE_%s(%s)\n", $4, $5) > syshide
	}
	$2 == "STD" || $2 == "NODEF" {
		if (( !nosys || $5 != "nosys" ) && ( !lkmnosys ||
			$5 != "lkmnosys"))
			printf("int\t%s();\n", $5) > sysdcl
		if ($5 == "nosys")
			nosys = 1
		if ($5 == "lkmnosys")
			lkmnosys = 1
		printf("\t{ %d, %s },\t\t\t/* %d = %s */\n", \
		    $3, $5, syscall, $6) > sysent
		printf("\t\"%s\",\t\t\t/* %d = %s */\n", \
		    $6, syscall, $6) > sysnames
		if ($2 == "STD")
			printf("#define\tSYS_%s\t%d\n", \
		    	    $6, syscall) > syshdr
		syscall++
		next
	}
	$2 == "COMPAT" {
		printf("int\to%s();\n", $5) > syscompat
		printf("\t{ compat(%d,%s) },\t\t/* %d = old %s */\n", \
		    $3, $5, syscall, $6) > sysent
		printf("\t\"old.%s\",\t\t/* %d = old %s */\n", \
		    $6, syscall, $6) > sysnames
		printf("\t\t\t\t/* %d is old %s */\n", \
		    syscall, comment) > syshdr
		syscall++
		next
	}
	$2 == "LIBCOMPAT" {
		printf("int\to%s();\n", $5) > syscompat
		printf("\t{ compat(%d,%s) },\t\t/* %d = old %s */\n", \
		    $3, $5, syscall, $6) > sysent
		printf("\t\"old.%s\",\t\t/* %d = old %s */\n", \
		    $6, syscall, $6) > sysnames
		printf("#define\tSYS_%s\t%d\t/* compatibility; still used by libc */\n", \
		    $6, syscall) > syshdr
		syscall++
		next
	}
	$2 == "OBSOL" {
		printf("\t{ 0, nosys },\t\t\t/* %d = obsolete %s */\n", \
		    syscall, comment) > sysent
		printf("\t\"obs_%s\",\t\t\t/* %d = obsolete %s */\n", \
		    $5, syscall, comment) > sysnames
		printf("\t\t\t\t/* %d is obsolete %s */\n", \
		    syscall, comment) > syshdr
		syscall++
		next
	}
	$2 == "UNIMPL" {
		printf("\t{ 0, nosys },\t\t\t/* %d = %s */\n", \
		    syscall, comment) > sysent
		printf("\t\"#%d\",\t\t\t/* %d = %s */\n", \
		    syscall, syscall, comment) > sysnames
		syscall++
		next
	}
	{
		printf "%s: line %d: unrecognized keyword %s\n", infile, NR, $2
		exit 1
	}
	END {
		printf("\n#else /* %s */\n", compat) > syscompat
		printf("#define compat(n, name) 0, nosys\n") > syscompat
		printf("#endif /* %s */\n\n", compat) > syscompat

		printf("};\n\n") > sysent
		printf ("struct sysentvec aout_sysvec = {\n") > sysent
		printf ("\tsizeof (sysent) / sizeof (sysent[0]),\n") > sysent
		printf ("\tsysent,\n") > sysent
		printf ("\t0,\n\t0,\n\t0,\n\t0,\n\t0,\n\t0\n};\n") > sysent
		printf("};\n") > sysnames
	} '

cat $sysdcl $syscompat $sysent >$syssw

chmod 444 $sysnames $syshdr $syssw $syshide

