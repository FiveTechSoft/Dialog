#include "dialog.ch"
#include "inkey.ch"

#define K_SPACE 32

//----------------------------------------------------------------------------//

CLASS PushButton FROM Visual

   VAR cText
   VAR cClrDefault, cClrHotKey, cClrInactive
   VAR lDefault, lPressed

   METHOD New        = PbtNew
   METHOD Display    = PbtDisplay
   METHOD KeyPressed = PbtKeyPressed
   METHOD Click      = PbtClick
   METHOD DblClick   = PbtDblClick
   METHOD SetFocus   = PbtSetFocus
   METHOD lIsOver    = lPbtIsOver
   METHOD GoDown     = PbtGoDown
   METHOD cGetHotKey = cPbtGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function PbtNew( nRow, nCol, cText, nId, cMessage )

   DEFAULT nRow = 0, nCol = 0, cText = "&PushButton", nId = 0,;
           cMessage = "" 

   ::Parent:New()

   ::nTop         = nRow
   ::nLeft        = nCol
   ::nBottom      = nRow + 1
   ::nRight       = nCol + Len( StrTran( cText, "&", "",, 1 ) )
   ::cText        = cText
   ::nId          = nId
   ::cMessage     = cMessage
   ::cClrNormal   = "N/G"
   ::cClrHotKey   = "GR+/G"
   ::cClrDefault  = "BG+/G"
   ::cClrInactive = "W/G"
   ::lPressed     = .f.
   ::lDefault     = .f.

return Self

//----------------------------------------------------------------------------//

METHOD function PbtDisplay()

   if ! ::lPressed
      BtnDraw( ::nAbsTop(),;
               ::nAbsLeft(),;
               ::cText,;
               nColor2N( If( ! ::lActive, ::cClrInactive,;
                         If( ::lFocused, ::cClrFocus,;
                         If( ::lDefault, ::cClrDefault, ::cClrNormal ) ) ) ),;
               nColor2N( If( ::lActive, ::cClrHotKey, ::cClrInactive ) ) )
   else
      SayHot( ::nAbsTop(),;
              ::nAbsLeft() + 1, ::cText,;
              If( ::lFocused, ::cClrFocus,;
              If( ! ::lActive, ::cClrInactive,;
              If( ::lDefault, ::cClrDefault, ::cClrNormal ) ) ),;
              ::cClrHotKey )
   endif

return

//----------------------------------------------------------------------------//

METHOD function PbtKeyPressed( nKey )

   do case
      case nKey == K_ESC
           if ::oParent == nil
              ::EndExec()
           endif

      case nKey == K_SPACE .or. nKey == K_ENTER
           ::GoDown()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function PbtClick( nRow, nCol )

   if ::lDrag
      ::DragOver()
   else
      if ::lActive
         ::GoDown()
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function PbtDblClick( nRow, nCol )

   ::Click()

return

//----------------------------------------------------------------------------//

METHOD function PbtSetFocus( lOnOff, cColor )

   ::Parent:SetFocus( lOnOff, cColor )
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function lPbtIsOver( nRow, nCol )

return nRow == ::nAbsTop() .and. ;
       nCol >= ::nAbsLeft() .and. ;
      nCol <= ::nAbsLeft() + ( ::nRight - ::nLeft ) - 1 + if( ::lPressed, 1, 0 )

//----------------------------------------------------------------------------//

METHOD function PbtGoDown()

   local nMCrsOld := SetMCursor()

   ::lPressed = .t.
   SetMCursor( .f. )
   RestScreen( ::nAbsTop(),;
               ::nAbsLeft(),;
               ::nAbsTop() + ( ::nBottom - ::nTop ),;
               ::nAbsLeft() + ( ::nRight - ::nLeft ),;
               ::cBackImage )
   ::Display()
   SetMCursor( nMCrsOld )
   if lMPressed()
      do while lMPressed()
         if ::lIsOver( nMRow(), nMCol() )
            if ! ::lPressed
               ::lPressed = .t.
               SetMCursor( .f. )
               RestScreen( ::nAbsTop(),;
                           ::nAbsLeft(),;
                           ::nAbsTop() + ( ::nBottom - ::nTop ),;
                           ::nAbsLeft() + ( ::nRight - ::nLeft ),;
                           ::cBackImage )
               ::Display()
               SetMCursor( nMCrsOld )
            endif
         else
            if ::lPressed
               ::lPressed = .f.
               SetMCursor( .f. )
               RestScreen( ::nAbsTop(),;
                           ::nAbsLeft(),;
                           ::nAbsTop() + ( ::nBottom - ::nTop ),;
                           ::nAbsLeft() + ( ::nRight - ::nLeft ),;
                           ::cBackImage )
               ::Display()
               SetMCursor( nMCrsOld )
            endif
         endif
         MUpdate()
      enddo
   else
      InKey( 0.2 )
   endif
   if ::lPressed
      if ::oParent != nil
         ::oParent:PbtClick( Self )
      else
         ::EndExec()
      endif
      SetMCursor( .f. )
      RestScreen( ::nAbsTop(),;
                  ::nAbsLeft(),;
                  ::nAbsTop() + ( ::nBottom - ::nTop ),;
                  ::nAbsLeft() + ( ::nRight - ::nLeft ),;
                  ::cBackImage )
      ::lPressed = .f.
      ::Display()
      SetMCursor( nMCrsOld )
   endif

return

//----------------------------------------------------------------------------//

METHOD function cPbtGetHotKey()

   local nAt := At( "&", ::cText )

return If( nAt != 0, SubStr( ::cText, nAt + 1, 1 ), "" )

//----------------------------------------------------------------------------//
