#if defined(LIBC_SCCS) && !defined(lint)
static char *rcsid = "shmdt.c,v 1.1 1994/09/13 14:52:31 dfr Exp";
#endif /* LIBC_SCCS and not lint */

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#if __STDC__
int shmdt(void *shmaddr)
#else
int shmdt(shmaddr)
	void *shmaddr;
#endif
{
	return (shmsys(2, shmaddr));
}
