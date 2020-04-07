#include <dos.h>
#include "e:\clipper5\include\extend.h"

CLIPPER lKeyAlt()
{
   _retl( peekb( 0, 0x417 ) & 8 );
}
