#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS PbMenu FROM Menu

   METHOD New        = PbmNew
   METHOD KeyPressed = PbmKeyPressed
   METHOD Click      = PbmClick
   METHOD PbtClick   = PbmPbtClick
   METHOD cGetHotKey = cPbmGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function PbmNew( nRow, nCol, nId )

   DEFAULT nId = 0

   ::Parent:New()

   ::Move( nRow, nCol )
   ::nId = nId

return Self

//----------------------------------------------------------------------------//

METHOD function PbmKeyPressed( nKey )

   if nKey == K_ENTER .or. nKey == 32
      ::aItems[ ::nOption ]:KeyPressed( 32 )
   else
      ::Parent:KeyPressed( nKey )
   endif
   if ::nOption != 0
      if Upper( Chr( nKey ) ) == Upper( ::aItems[ ::nOption ]:cGetHotKey() )
         ::aItems[ ::nOption ]:KeyPressed( 32 )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function PbmClick( nMRow, nMCol )

   local nAt

   do while lMPressed()
      nAt := AScan( ::aItems, { | oItem | oItem:lIsOver( nMRow, nMCol ) } )
      if nAt != 0
         if nAt != ::nOption
            ::SetOption( nAt )
         endif
         ::aItems[ ::nOption ]:Click( nMRow, nMCol )
      endif
      MUpdate()
      nMRow = nMRow()
      nMCol = nMCol()
   enddo

return

//----------------------------------------------------------------------------//

METHOD function PbmPbtClick( oPbt )

   if ::oParent != nil
      ::oParent:PbmChanged( Self )
   else
      ::EndExec()
   endif

return

//----------------------------------------------------------------------------//

METHOD function cPbmGetHotKey()
return ""

//----------------------------------------------------------------------------//
