#include "e:\clipper5\include\extend.h"
#include <dos.h>

CLIPPER lChDir()
{
   char * szPath = _parc( 1 );

   asm push ds;

   _DX = FP_OFF( szPath );
   _DS = FP_SEG( szPath );
   _AH = 0x3B;
   geninterrupt( 0x21 );

   asm pop ds;

   _retl( _AX != 3 );
}
