#include "dialog.ch"

//----------------------------------------------------------------------------//

CLASS Label FROM Visual

   VAR cText
   VAR cClrHotKey

   METHOD New        = LblNew
   METHOD Display    = LblDisplay
   METHOD SetFocus   = LblSetFocus
   METHOD cGetHotKey = cLblGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function LblNew( nRow, nCol, cText )

   DEFAULT cText = "&Label"

   ::Parent:New()

   ::nTop       = nRow
   ::nLeft      = nCol
   ::nBottom    = nRow
   ::nRight     = nCol + nLabelLen( cText ) - 1
   ::cText      = cText
   ::cClrHotKey = "GR+/W"

return Self

//----------------------------------------------------------------------------//

METHOD function LblDisplay()

   local nMCrsOld := SetMCursor()

   SetMCursor( 0 )
   SayHot( ::nAbsTop(), ::nAbsLeft(), ::cText,;
           If( ::lFocused, ::cClrFocus, ::cClrNormal ),;
           ::cClrHotKey )
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function LblSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function cLblGetHotKey()

   local nAt := At( "&", ::cText )

return If( nAt != 0, SubStr( ::cText, nAt + 1, 1 ), "" )

//----------------------------------------------------------------------------//
