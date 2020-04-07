#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS ComboBox FROM Edit

   VAR cClrOpened
   VAR oListBox
   VAR lOpened

   METHOD New        = CbxNew
   METHOD Display    = CbxDisplay
   METHOD Hide       = CbxHide
   METHOD KeyPressed = CbxKeyPressed
   METHOD Click      = CbxClick
   METHOD DblClick   = CbxDblClick
   METHOD lIsOver    = lCbxIsOver
   METHOD SetFocus   = CbxSetFocus
   METHOD LbxSelect  = CbxLbxSelect
   METHOD LbxChanged = CbxLbxChanged
   METHOD LbxChoosed = CbxLbxChoosed
   METHOD Open       = CbxOpen
   METHOD Close      = CbxClose

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function CbxNew( nRow, nCol, nLen, cText, nId, cLabel, cMessage )

   DEFAULT cLabel = "&ComboBox"

   ::Parent:New( nRow, nCol, nLen, cText, nId, cLabel, cMessage )

   ::nRight++
   ::oListBox = ListBox():New( 1, 0, 5, ::nRight - ::nLeft, "", 0, "" )
   ::oListBox:oLabel   = nil
   ::oListBox:cMessage = nil
   ::oListBox:oParent  = Self
   ::lOpened           = .f.
   ::cClrOpened        = "BG+/BG"

return Self

//----------------------------------------------------------------------------//

METHOD function CbxDisplay()

   local nMCrsOld := SetMCursor()

   SetCursor( 0 )
   SetMCursor( 0 )
   @ ::nAbsTop(), ::nAbsLeft() + ::nLen + 2 ;
     SAY If( ::lOpened, Chr( 30 ), Chr( 31 ) ) COLOR "BG+/B"
   SetMCursor( nMCrsOld )
   ::Parent:Display()

return

//----------------------------------------------------------------------------//

METHOD function CbxHide()

   if ::lOpened
      ::Close()
   endif
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function CbxKeyPressed( nKey )

   do case
      case nKey == K_ESC
           if ::lOpened
              ::Close()
           endif

      case nKey == K_ENTER .and. ::lOpened
           ::SetText( ::oListBox:acItems[ ::oListBox:nOption ] )
           ::Close()

      case ::lOpened
           ::oListBox:KeyPressed( nKey )

      case nKey == K_DOWN
           ::Open()

      otherwise
           ::Parent:KeyPressed( nKey )
   endcase

return

//----------------------------------------------------------------------------//

METHOD function CbxClick( nMRow, nMCol )

   if ::lOpened
      if ::oListBox:lIsOver( nMRow, nMCol )
         ::oListBox:Click( nMRow, nMCol )
      else
         if nMRow == ::nAbsTop() .and. ;
            nMCol == ::nAbsLeft() + ::nRight - ::nLeft
            ::Close()
         endif
      endif
   else
      if nMRow == ::nAbsTop() .and. nMCol == ::nAbsLeft() + ::nRight - ::nLeft
         ::Open()
      else
         ::Parent:Click( nMRow, nMCol )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function CbxDblClick( nMRow, nMCol )

   if ::lOpened
      if ::oListBox:lIsOver( nMRow, nMCol )
         ::oListBox:DblClick( nMRow, nMCol )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function lCbxIsOver( nRow, nCol )

   local lIsOver := .f.

   if ::lOpened
      lIsOver = ::oListBox:lIsOver( nRow, nCol )
   endif

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function CbxSetFocus( lOnOff, cClrFocus )

   if ! lOnOff .and. ::lOpened
      ::Close()
   endif
   ::Parent:SetFocus( lOnOff, cClrFocus )

return

//----------------------------------------------------------------------------//

METHOD function CbxLbxSelect( oLbx )
return

//----------------------------------------------------------------------------//

METHOD function CbxLbxChanged( oLbx )
return

//----------------------------------------------------------------------------//

METHOD function CbxLbxChoosed( oLbx )

   ::SetText( ::oListBox:acItems[ ::oListBox:nOption ] )
   ::Close()
   if ::oParent != nil
      ::oParent:CbxSelect( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function CbxOpen()

   local nMCrsOld := SetMCursor()

   if ! ::lOpened
      ::lOpened = .t.
      SetCursor( 0 )
      SetMCursor( 0 )
      @ ::nAbsTop(), ::nAbsLeft() SAY " " COLOR ::cClrNormal
      @ ::nAbsTop(), ::nAbsLeft() + ::nLen + 1 SAY " " COLOR ::cClrNormal
      @ ::nAbsTop(), ::nAbsLeft() + 1 ;
        SAY SubStr( ::cText, ::nStartCol, ::nLen ) COLOR ::cClrOpened
      @ ::nAbsTop(), ::nAbsLeft() + ::nRight - ::nLeft ;
        SAY Chr( 30 ) COLOR "BG+/B"
      ::oListBox:Show()
      ::oListBox:SetFocus( .t., ::cClrFocus )
      SetMCursor( nMCrsOld )
   endif

return

//----------------------------------------------------------------------------//

METHOD function CbxClose()

   local nMCrsOld := SetMCursor()

   if ::lOpened
      ::lOpened = .f.
      ::oListBox:Hide()
      SetMCursor( 0 )
      @ ::nAbsTop(), ::nAbsLeft() + ::nLen + 2 ;
        SAY Chr( 31 ) COLOR "BG+/B"
      ::BufDisplay()
      SetMCursor( nMCrsOld )
   endif

return

//----------------------------------------------------------------------------//
