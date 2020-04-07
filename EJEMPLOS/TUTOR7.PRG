#include "dialog.ch"

//----------------------------------------------------------------------------//

function Main()

   local pbmTest := PbMenu():New()

   pbmTest:AddItem( PushButton():New( 7, 30, " &Altas          ", 1,;
                    " Altas de Clientes " ) )
   pbmTest:AddItem( PushButton():New( 9, 30, " &Modificaciones ", 2,;
                    " Modificaci¢n de Informaci¢n " ) )
   pbmTest:AddItem( PushButton():New( 11, 30, " &Bajas          ", 3,;
                    " Bajas de Clientes " ) )

   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   pbmTest:Exec()
   Alert( Str( pbmTest:nOption ) )
   pbmTest:Hide()

return

//----------------------------------------------------------------------------//
