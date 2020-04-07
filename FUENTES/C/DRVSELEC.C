#include "e:\clipper5\include\extend.h"

CLIPPER DrvSelect()
{
   unsigned char ucDrive = _parni( 1 );

   _AH = 0x0E;
   _DL = ucDrive;
   asm int 0x21;
}
