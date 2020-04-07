#include "e:\clipper5\include\extend.h"

unsigned char ucColor2N( char * );

CLIPPER SayHot()
{
   ScrSayHot( _parni( 1 ),
              _parni( 2 ),
              _parc( 3 ),
              ucColor2N( _parc( 4 ) ),
              ucColor2N( _parc( 5 ) ) );
}
