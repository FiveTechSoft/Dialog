#include "dialog.ch"

//----------------------------------------------------------------------------//

CLASS CheckBtn FROM Visual

   VAR cText
   VAR lChecked
   VAR cClrHotKey

   METHOD New        = CbtNew
   METHOD Display    = CbtDisplay
   METHOD SetFocus   = CbtSetFocus
   METHOD KeyPressed = CbtKeyPressed
   METHOD Click      = CbtClick
   METHOD DblClick   = CbtDblClick
   METHOD cGetHotKey = cCbtGetHotKey
   METHOD SetText    = CbtSetText

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function CbtNew( nRow, nCol, cText, nId, cMessage )

   DEFAULT nRow = 0, nCol = 0, cText = "&CheckButton", nId = 0, cMessage = ""

   ::Parent:New()

   ::nTop       = nRow
   ::nLeft      = nCol
   ::nBottom    = nRow
   ::nRight     = nCol + 5 + nLabelLen( cText ) - 1
   ::nId        = nId
   ::cText      = cText
   ::cMessage   = cMessage
   ::lChecked   = .f.
   ::cClrHotKey = "GR+/W"

return Self

//----------------------------------------------------------------------------//

METHOD function CbtDisplay()

   local nMCrsOld := SetMCursor()

   SetMCursor( .f. )
   SayHot( ::nAbsTop(), ::nAbsLeft(),;
           " [" + If( ::lChecked, "X", " " ) + "] " + ::cText,;
           If( ! ::lActive, ::cClrInactive,;
               If( ::lFocused, ::cClrFocus, ::cClrNormal ) ), ::cClrHotKey )
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function CbtSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function CbtKeyPressed( nKey )

   ::lChecked = ! ::lChecked
   if ::oParent != nil
      ::oParent:CbtChanged( Self )
   endif
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function CbtClick( nMRow, nMCol )

   ::lChecked = ! ::lChecked
   if ::oParent != nil
      ::oParent:CbtChanged( Self )
   endif
   ::Display()
   do while lMPressed()
      MUpdate()
   enddo

return

//----------------------------------------------------------------------------//

METHOD function CbtDblClick( nMRow, nMCol )

   ::Click( nMRow, nMCol )

return

//----------------------------------------------------------------------------//

METHOD function cCbtGetHotKey()

   local nAt := At( "&", ::cText )

return If( nAt != 0, SubStr( ::cText, nAt + 1, 1 ), "" )

//----------------------------------------------------------------------------//

METHOD function CbtSetText( cText )

   ::cText  = cText
   ::nRight = ::nLeft + 5 + nLabelLen( cText ) - 1

return

//----------------------------------------------------------------------------//
