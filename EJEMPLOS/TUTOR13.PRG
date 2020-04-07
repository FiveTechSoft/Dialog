#include "dialog.ch"

#define ID_nHOLA 100

//----------------------------------------------------------------------------//

function Main()

   local oPbt := PushButton():New( 10, 10, " &Hola ", ID_nHOLA,;
                                   " ¨ C¢mo est s ?" )

   SetColor( "W+/B" )
   CLS

   oPbt:Exec()

return

//----------------------------------------------------------------------------//
