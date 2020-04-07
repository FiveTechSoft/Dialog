#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS Window FROM Visual

   VAR cClrTitle
   VAR cImage, cTitle
   VAR lCloseable, lMaximizable

   METHOD New        = WndNew
   METHOD Display    = WndDisplay
   METHOD Click      = WndClick
   METHOD Say        = WndSay
   METHOD Box        = WndBox

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function WndNew( nTop, nLeft, nBottom, nRight, cTitle )

   DEFAULT nTop = 10, nLeft = 10, nBottom = 20, nRight = 60, cTitle = ""

   ::Parent:New( nTop, nLeft, nBottom, nRight )

   ::nTop         = nTop
   ::nLeft        = nLeft
   ::nBottom      = nBottom
   ::nRight       = nRight
   ::cClrTitle    = "W+/R"
   ::cImage       = ""
   ::cTitle       = If( ! Empty( cTitle ), " " + AllTrim( cTitle ) + " ", "" )
   ::lCloseable   = .t.
   ::lMaximizable = .f.
   ::lShadowed    = .t.

return Self

//----------------------------------------------------------------------------//

METHOD function WndDisplay()

   @ ::nTop, ::nLeft, ::nBottom, ::nRight ;
      BOX If( ::lCloseable, "þ", "Ú" ) + "Ä" + ;
          If( ::lMaximizable, "", "¿" ) + "³ÙÄÀ³ " COLOR ::cClrNormal
   ScrShadow( ::nBottom + 1, ::nLeft + 2, ::nBottom + 1, ::nRight + 2 )
   ScrShadow( ::nTop + 1, ::nRight + 1, ::nBottom, ::nRight + 2 )
   if ! Empty( ::cTitle )
      @ ::nTop, ::nLeft + ( ( ::nRight - ::nLeft ) / 2 ) - ;
        ( Len( ::cTitle ) / 2 ) SAY ::cTitle COLOR ::cClrTitle
   endif

return

//----------------------------------------------------------------------------//

METHOD function WndClick( nRow, nCol )

   if nRow == ::nAbsTop() .and. nCol == ::nAbsLeft()
      ::lEndExec = .t.
   endif

return

//----------------------------------------------------------------------------//

METHOD function WndSay( nRow, nCol, cText, cColor )

   local nMCrsOld := SetMCursor()

   DEFAULT cColor = ::cClrNormal

   SetMCursor( 0 )
   @ ::nAbsTop() + nRow, ::nAbsLeft() + nCol SAY cText COLOR cColor
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function WndBox( nTop, nLeft, nBottom, nRight, cColor )

   local nMCrsOld := SetMCursor()

   DEFAULT cColor = ::cClrNormal

   SetMCursor( 0 )
   @ ::nAbsTop() + nTop, ::nAbsLeft() + nLeft TO ;
     ::nAbsTop() + nBottom, ::nAbsLeft() + nRight COLOR cColor
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//
