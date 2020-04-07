#include "extend.h"
#include <dos.h>

CLIPPER BtnDraw()
{
   unsigned int uiRow        = _parni( 1 );
   unsigned int uiCol        = _parni( 2 );
   char * szLabel            = _parc( 3 );
   unsigned char ucClrNormal = _parni( 4 );
   unsigned char ucClrHotKey = _parni( 5 );
   char * pcVideo            = ( char * ) ( peekb( 0, 0x449 ) == 7 ?
                               0xB0000000: 0xB8000000 );
   unsigned int uiOffset     = ( uiRow * 160 ) + ( uiCol * 2 );
   char c = 0;

   while( szLabel[ c ] )
   {
      if( szLabel[ c ] != '&' )
      {
         pcVideo[ uiOffset ] = szLabel[ c ];
         pcVideo[ uiOffset + 1 ] = ucClrNormal;
      }
      else
      {
         c++;
         pcVideo[ uiOffset ] = szLabel[ c ];
         pcVideo[ uiOffset + 1 ] = ucClrHotKey;
      }
      if( c > 0 )
      {
         pcVideo[ uiOffset + 160 ] = 'ß';
         pcVideo[ uiOffset + 161 ] = pcVideo[ uiOffset + 161 ] & 0xF0;
      }
      c++;
      uiOffset += 2;
   }
   pcVideo[ uiOffset ] = 'Ü';
   pcVideo[ uiOffset + 1 ] = pcVideo[ uiOffset + 1 ] & 0xF0;
   pcVideo[ uiOffset + 160 ] = 'ß';
   pcVideo[ uiOffset + 161 ] = pcVideo[ uiOffset + 161 ] & 0xF0;
}
