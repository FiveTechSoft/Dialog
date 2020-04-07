#include "dialog.ch"

//----------------------------------------------------------------------------//

CLASS RadioBtn FROM Visual

   VAR cText
   VAR lChecked
   VAR cClrHotKey

   METHOD New        = RbtNew
   METHOD Display    = RbtDisplay
   METHOD SetFocus   = RbtSetFocus
   METHOD KeyPressed = RbtKeyPressed
   METHOD Click      = RbtClick
   METHOD cGetHotKey = cRbtGetHotKey
   METHOD SetText    = RbtSetText

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function RbtNew( nRow, nCol, cText, nId, cMessage )

   DEFAULT nRow = 0, nCol = 0, cText = "&RadioButton", nId = 0, cMessage = ""

   ::Parent:New()

   ::nTop       = nRow
   ::nLeft      = nCol
   ::nBottom    = nRow
   ::nRight     = nCol + 5 + nLabelLen( cText ) - 1
   ::nId        = nId
   ::cText      = cText
   ::cMessage   = cMessage
   ::lChecked   = .f.
   ::cClrNormal = "N/BG"
   ::cClrHotKey = "GR+/W"

return Self

//----------------------------------------------------------------------------//

METHOD function RbtDisplay()

   local nMCrsOld := SetMCursor()

   SetMCursor( .f. )
   SayHot( ::nAbsTop(), ::nAbsLeft(),;
           " (" + If( ::lChecked, Chr( 7 ), " " ) + ") " + ::cText,;
           If( ! ::lActive, ::cClrInactive,;
               If( ::lFocused, ::cClrFocus, ::cClrNormal ) ), ::cClrHotKey )
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function RbtSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function RbtKeyPressed( nKey )

   ::lChecked = ! ::lChecked
   ::Display()
   if ::oParent != nil
      ::oParent:RbtChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function RbtClick( nRow, nCol )

   ::lChecked = ! ::lChecked
   ::Display()
   if ::oParent != nil
      ::oParent:RbtChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function cRbtGetHotKey()

   local nAt := At( "&", ::cText )

return If( nAt != 0, SubStr( ::cText, nAt + 1, 1 ), "" )

//----------------------------------------------------------------------------//

METHOD function RbtSetText( cText )

   ::cText  = cText
   ::nRight = ::nLeft + 5 + nLabelLen( cText ) - 1

return

//----------------------------------------------------------------------------//
