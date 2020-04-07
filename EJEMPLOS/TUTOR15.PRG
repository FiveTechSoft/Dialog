#include "dialog.ch"

#define ID_nPRUEBA 100

//----------------------------------------------------------------------------//

function Main()

   local dtsTest := DlgTest():New()

   SetColor( "W+/B" )
   CLS

   dtsTest:Exec()
   dtsTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR pbmPrueba

   METHOD New        = DtsNew          // M‚todo constructor obligatorio!
   METHOD Init       = DtsInit         // Redefinici¢n de m‚todo de Dialog
   METHOD PbmChanged = DtsPbmChanged   // Redefinici¢n de m‚todo de Dialog

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 8, 20, 15, 60, "­ Atenci¢n !" )

   ::pbmPrueba = PbMenu():New( 5, 2, ID_nPRUEBA )

   ::pbmPrueba:AddItem( PushButton():New( 0, 0, " &Cancelar ", 0,;
                        " Primera Opci¢n " ) )
   ::pbmPrueba:AddItem( PushButton():New( 0, 13, " &Reintentar ", 0,;
                        " Segunda Opci¢n " ) )
   ::pbmPrueba:AddItem( PushButton():New( 0, 28, " &Seguir ", 0,;
                        " Tercera Opci¢n " ) )

   ::AddControl( ::pbmPrueba )

return Self

//----------------------------------------------------------------------------//

METHOD function DtsInit()

   ::Say( 2, 8, "Se ha producido un error" )
   ::Say( 3, 8, "     (es broma...)      " )

return

//----------------------------------------------------------------------------//

METHOD function DtsPbmChanged( oPbMenu )

   do case
      case oPbMenu:nOption == 1
           ::Say( 3, 8, "      Puls¢ cancelar  " )

      case oPbMenu:nOption == 2
           ::Say( 3, 8, "      Puls¢ reintentar" )

      case oPbMenu:nOption == 3
           ::Say( 3, 8, "      Puls¢ seguir    " )
           ::EndExec()
   endcase

return

//----------------------------------------------------------------------------//
