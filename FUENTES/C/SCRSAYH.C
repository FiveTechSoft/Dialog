#include <dos.h>

void ScrSayHot( unsigned char ucRow, unsigned char ucCol, char * szText,
                unsigned char ucColor, unsigned char ucColorHot )
{
   unsigned char * pcVideo = ( char * ) ( peekb( 0, 0x449 ) == 7 ?
                               0xB0000000: 0xB8000000 );
   unsigned char uc = 0;
   unsigned int uiOffset = ( ucRow * 160 ) + ( ucCol * 2 );
   unsigned char ucByte;

   while( ucByte = szText[ uc++ ] )
   {
      if( ucByte == '&' )
      {
         ucByte = szText[ uc++ ];
         if( ucRow >= 0 && ucCol >= 0 )
         {
            pcVideo[ uiOffset ] = ucByte;
            pcVideo[ uiOffset + 1 ] = ( ( ucColorHot & 0x0F ) | ( ucColor & 0xF0 ) );
         }
      }
      else
      {
         if( ucRow >= 0 && ucCol >= 0)
         {
            pcVideo[ uiOffset ] = ucByte;
            pcVideo[ uiOffset + 1 ] = ucColor;
         }
      }
      ucCol++;
      uiOffset += 2;
   }
}
