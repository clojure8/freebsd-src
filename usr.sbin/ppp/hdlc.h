/*
 *	    Written by Toshiharu OHNO (tony-o@iij.ad.jp)
 *
 *   Copyright (C) 1993, Internet Initiative Japan, Inc. All rights reserverd.
 *
 * Redistribution and use in source and binary forms are permitted
 * provided that the above copyright notice and this paragraph are
 * duplicated in all such forms and that any documentation,
 * advertising materials, and other materials related to such
 * distribution and use acknowledge that the software was developed
 * by the Internet Initiative Japan.  The name of the
 * IIJ may not be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 * hdlc.h,v 1.2 1995/02/26 12:17:31 amurai Exp
 *
 *	TODO:
 */

#ifndef _HDLC_H_
#define _HDLC_H_

/*
 *  Definition for Async HDLC
 */
#define HDLC_SYN 0x7e	/* SYNC character */
#define HDLC_ESC 0x7d	/* Escape character */
#define HDLC_XOR 0x20	/* Modifier value */

#define	HDLC_ADDR 0xff
#define	HDLC_UI	  0x03
/*
 *  Definition for HDLC Frame Check Sequence
 */
#define INITFCS 0xffff	/* Initial value for FCS computation */
#define GOODFCS 0xf0b8	/* Good FCS value */

#define	DEF_MRU		1500
#define	MAX_MRU		2000
#define	MIN_MRU		296

/*
 *  Output priority
 */
#define	PRI_NORMAL	0	/* Normal priority */
#define	PRI_FAST	1	/* Fast (interructive) */
#define	PRI_URGENT	2	/* Urgent (LQR packets) */

unsigned char EscMap[33];

void HdlcInit __P((void));
void HdlcInput __P((struct mbuf *bp));
void HdlcOutput __P((int pri, u_short proto, struct mbuf *bp));
void AsyncOutput __P((int pri, struct mbuf *bp, int proto));

#endif
