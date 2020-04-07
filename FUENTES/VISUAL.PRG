#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS Visual

   VAR oParent
   VAR nTop, nLeft, nBottom, nRight
   VAR cBackImage, cMessage, cMsgBack
   VAR lActive, lDrag, lEndExec, lFocused, lShadowed, lVisible
   VAR cClrNormal, cClrFocus, cClrMessage
   VAR nId

   METHOD New           = VslNew
   METHOD Show          = VslShow
   METHOD Display       = VslDisplay
   METHOD Hide          = VslHide
   METHOD lIsOver       = lVslIsOver
   METHOD Click         = VslClick
   METHOD DblClick      = VslDblClick
   METHOD KeyPressed    = VslKey
   METHOD Exec          = VslExec
   METHOD EndExec       = VslEndExec
   METHOD SetFocus      = VslSetFocus
   METHOD nAbsTop       = nVslAbsTop
   METHOD nAbsLeft      = nVslAbsLeft
   METHOD DragOver      = VslDragOver
   METHOD Move          = VslMove
   METHOD CtrlGotFocus  = VslCtrlGotFocus
   METHOD CtrlLostFocus = VslCtrlLostFocus
   METHOD Init          = VslInit

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function VslNew()

   ::nTop        = 0
   ::nLeft       = 0
   ::nBottom     = 0
   ::nRight      = 0
   ::cBackImage  = ""
   ::cMessage    = ""
   ::cMsgBack    = ""
   ::lActive     = .t.
   ::lDrag       = .f.
   ::lEndExec    = .f.
   ::lFocused    = .f.
   ::lShadowed   = .f.
   ::lVisible    = .f.
   ::cClrNormal  = "N/W"
   ::cClrFocus   = nil
   ::cClrMessage = "N/W"
   ::nId         = 0

return Self

//----------------------------------------------------------------------------//

METHOD function VslShow()

   if ! ::lVisible
      ::lVisible = .t.
      ::cBackImage = ;
      SaveScreen( ::nAbsTop(),;
                  ::nAbsLeft(),;
                  ::nAbsTop() + ( ::nBottom - ::nTop ) + if( ::lShadowed, 1, 0 ),;
                  ::nAbsLeft() + ( ::nRight - ::nLeft ) + if( ::lShadowed, 2, 0 ) )
      ::cMsgBack = SaveScreen( MaxRow(), 0, MaxRow(), 79 )
   endif
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function VslDisplay()

return

//----------------------------------------------------------------------------//

METHOD function VslHide()

   local nMCrsOld := SetMCursor()

   if ::lVisible
      ::lVisible = .f.
      ::lFocused = .f.
      SetMCursor( .f. )
      RestScreen( ::nAbsTop(),;
                  ::nAbsLeft(),;
                  ::nAbsTop() + ( ::nBottom - ::nTop ) + if( ::lShadowed, 1, 0 ),;
                  ::nAbsLeft() + ( ::nRight - ::nLeft ) + if( ::lShadowed, 2, 0 ),;
                  ::cBackImage )
      ::cBackImage = ""
      RestScreen( MaxRow(), 0, MaxRow(), 79, ::cMsgBack )
      ::cMsgBack = ""
      SetMCursor( nMCrsOld )
   endif

return

//----------------------------------------------------------------------------//

METHOD function lVslIsOver( nRow, nCol )

return nRow >= ::nAbsTop() .and. ;
       nRow <= ::nAbsTop() + ( ::nBottom - ::nTop ) .and. ;
       nCol >= ::nAbsLeft() .and. nCol <= ::nAbsLeft() + ( ::nRight - ::nLeft )

//----------------------------------------------------------------------------//

METHOD function VslClick( nMRow, nMCol )

return

//----------------------------------------------------------------------------//

METHOD function VslDblClick( nMRow, nMCol )

return

//----------------------------------------------------------------------------//

METHOD function VslKey( nKey )

return

//----------------------------------------------------------------------------//

METHOD function VslExec()

   local nMCrsOld := SetMCursor()
   local nKey
   local nOldMRow := 0, nOldMCol := 0
   local nLastClick := 0

   SetCursor( 0 )

   ::Show()
   if ! ::lFocused
      ::SetFocus( .t., "W+/B" )
   endif
   ::Init()
   ::lEndExec = .f.

   do while ! ::lEndExec
      nKey = nMKeyWait()
      do case
         case nKey == 0
              if ::lIsOver( nMRow(), nMCol() )
                 if Seconds() - nLastClick < 0.5 .and. ;
                    nMRow() == nOldMRow .and. nMCol() == nOldMCol
                    ::DblClick( nMRow(), nMCol() )
                 else
                    nLastClick  = Seconds()
                    nOldMRow    = nMRow()
                    nOldMCol    = nMCol()
                    ::Click( nMRow(), nMCol() )
                 endif
              else
                 Tone( 1000, 0.1 )
                 do while lMPressed()
                    MUpdate()
                 enddo
              endif

         otherwise
              ::KeyPressed( nKey )
      endcase
   enddo

   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function VslEndExec

   ::lEndExec = .t.

return

//----------------------------------------------------------------------------//

METHOD function VslSetFocus( lOnOff, cClrFocus )

   ::lFocused = lOnOff
   If lOnOff .and. ::cClrFocus == nil
      ::cClrFocus = SubStr( cClrFocus, 1, At( "/", cClrFocus ) ) + ;
                    SubStr( ::cClrNormal, At( "/", ::cClrNormal ) + 1 )
   endif
   if lOnOff .and. ::cMessage != nil
      @  MaxRow(), 0 SAY PadR( ::cMessage, 80 ) COLOR ::cClrMessage
   endif
   if ::oParent != nil
      if lOnOff
         ::oParent:CtrlGotFocus( Self )
      else
         ::oParent:CtrlLostFocus( Self )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function nVslAbsTop()

return ::nTop + if( ::oParent != nil, ::oParent:nAbsTop(), 0 )

//----------------------------------------------------------------------------//

METHOD function nVslAbsLeft()

return ::nLeft + if( ::oParent != nil, ::oParent:nAbsLeft(), 0 )

//----------------------------------------------------------------------------//

METHOD function VslDragOver()

   local nMOldRow := nMRow(), nMOldCol := nMCol()

   do while lMPressed()
      if nMRow() != nMOldRow .or. nMCol() != nMOldCol
         ::Move( nMRow(), nMCol() )
         nMOldRow = nMRow()
         nMOldCol = nMCol()
      endif
      MUpdate()
   enddo

return

//----------------------------------------------------------------------------//

METHOD function VslMove( nRow, nCol )

   local nMCrsOld    := SetMCursor()
   local nWidth      := ::nRight - ::nLeft
   local nHeigh      := ::nBottom - ::nTop
   local lWasVisible := ::lVisible

   if ::lVisible
      SetMCursor( 0 )
      ::Hide()
   endif
   ::nTop    = nRow
   ::nLeft   = nCol
   ::nBottom = nRow + nHeigh
   ::nRight  = nCol + nWidth
   if lWasVisible
      ::Show()
      ::SetFocus( .t., ::cClrFocus )
      SetMCursor( nMCrsOld )
   endif

return

//----------------------------------------------------------------------------//

METHOD function VslCtrlGotFocus( oControl )

return

//----------------------------------------------------------------------------//

METHOD function VslCtrlLostFocus( oControl )

return

//----------------------------------------------------------------------------//

METHOD function VslInit()

return

//----------------------------------------------------------------------------//
