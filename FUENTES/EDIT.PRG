#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS Edit FROM Visual

   VAR cText
   VAR cClrBlock, cClrFocus
   VAR nCrsPos, nBlkStart, nBlkEnd
   VAR nLen, nMaxLen, nStartCol
   VAR lInsert
   VAR oLabel

   METHOD New        = EdtNew
   METHOD Display    = EdtDisplay
   METHOD Hide       = EdtHide
   METHOD BufDisplay = EdtBufDisplay
   METHOD SetFocus   = EdtSetFocus
   METHOD lIsOver    = lEdtIsOver
   METHOD KeyPressed = EdtKeyPressed
   METHOD Click      = EdtClick
   METHOD GoLeft     = EdtGoLeft
   METHOD GoRight    = EdtGoRight
   METHOD Clear      = EdtClear
   METHOD SetText    = EdtSetText
   METHOD cGetHotKey = cEdtGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function EdtNew( nRow, nCol, nLen, cText, nId, cLabel, cMessage )

   DEFAULT nRow = 0, nCol = 0, nLen = 10, cText = "", nId = 0,;
           cLabel = "&Edit", cMessage = ""

   ::Parent:New()

   ::nTop            = nRow
   ::nLeft           = nCol
   ::nBottom         = nRow
   ::nRight          = nCol + nLen + 1
   ::nLen            = nLen
   ::nMaxLen         = nLen
   ::cText           = cText
   ::nId             = nId
   ::oLabel          = Label():New( -1, 0, cLabel )
   ::oLabel:cMessage = nil
   ::oLabel:oParent  = Self
   ::cMessage        = cMessage
   ::cClrBlock       = "W+/G"
   ::cClrFocus       = "W+/N"
   ::cClrNormal      = "N/BG"
   ::nCrsPos         = 1
   ::nStartCol       = 1
   ::nBlkStart       = 0
   ::nBlkEnd         = 0
   ::lInsert         = .f.

return Self

//----------------------------------------------------------------------------//

METHOD function EdtDisplay()

   local nMCrsOld := SetMCursor()

   if ::oLabel != nil
      ::oLabel:Show()
   endif

   SetMCursor( 0 )
   @ ::nAbsTop(), ::nAbsLeft() SAY Space( ::nLen + 2 ) ;
     COLOR ::cClrNormal
   ::BufDisplay()
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function EdtHide()

   SetCursor( 0 )
   if ::oLabel != nil
      ::oLabel:Hide()
   endif
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function EdtSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   if ::oLabel != nil
      ::oLabel:SetFocus( lOnOff, cClrFocus )
   endif
   ::Display()

return

//----------------------------------------------------------------------------//

METHOD function lEdtIsOver( nRow, nCol )

   local lIsOver := If( ::oLabel != nil, ::oLabel:lIsOver( nRow, nCol ), .f. )

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function EdtKeyPressed( nKey )

   do case
      case nKey == K_ESC
           if ::oParent == nil
              ::EndExec()
           endif

      case nKey >= 32
           ::cText = SubStr( ::cText, 1, ::nStartCol + ::nCrsPos - 1 -;
                     If( ::nCrsPos < ::nLen - 1, 1, 0 ) ) + ;
                     Chr( nKey ) + ;
                     SubStr( ::cText, ::nStartCol + ::nCrsPos - ;
                     If( ::lInsert, 1, 0 ) )
           ::cText = SubStr( ::cText, 1, ::nMaxLen )
           if ::nStartCol + ::nCrsPos - 1 < Len( ::cText ) + 2
              if ::nCrsPos < ::nLen
                 ::nCrsPos++
              else
                 if ::nStartCol < Len( ::cText ) - ::nLen + 1
                    ::nStartCol++
                 endif
              endif
           endif
           ::BufDisplay()
           if ::oParent != nil
              ::oParent:EdtChanged( Self )
           endif

      case nKey == K_HOME
           if ::nStartCol != 1 .or. ::nCrsPos != 1
              ::nCrsPos   = 1
              ::nStartCol = 1
              ::BufDisplay()
           endif

      case nKey == K_END
           if ::nStartCol + ::nCrsPos - 1 < Len( ::cText )
              ::nStartCol = If( Len( ::cText ) < ::nLen, 1,;
                                Len( ::cText ) - ::nLen + 1 )
              ::nCrsPos   = Min( ::nLen, Len( ::cText ) - ::nStartCol + 2 )
              ::BufDisplay()
           endif

      case nKey == K_INS
           ::lInsert = ! ::lInsert
           SetCursor( If( ::lInsert, 2, 1 ) )

      case nKey == K_LEFT
           ::GoLeft()

      case nKey == K_RIGHT
           ::GoRight()

       case nKey == K_DEL
            if ::nCrsPos <= Len( ::cText )
               ::cText = SubStr( ::cText, 1, ::nStartCol + ::nCrsPos - 2 ) + ;
                           SubStr( ::cText, ::nStartCol + ::nCrsPos )
               ::BufDisplay()
               if ::oParent != nil
                  ::oParent:EdtChanged( Self )
               endif
            endif

      case nKey == K_BS
           if ! Empty( ::cText )
              ::cText = SubStr( ::cText, 1, ::nStartCol + ::nCrsPos - 3 ) + ;
                        SubStr( ::cText, ::nStartCol + ::nCrsPos - 1 )
              if ::nCrsPos > 1
                 ::nCrsPos--
              else
                 if ::nStartCol > 1
                    ::nStartCol--
                 endif
              endif
              ::BufDisplay()
              if ::oParent != nil
                 ::oParent:EdtChanged( Self )
              endif
           endif
   endcase

return

//----------------------------------------------------------------------------//

METHOD function EdtClick( nMRow, nMCol )

   do case
      case ::nAbsTop() == nMRow .and. ::nAbsLeft() == nMCol
           do while lMPressed()
              if ::nAbsTop() == nMRow .and. ::nAbsLeft() == nMCol
                 ::GoLeft()
              endif
              MUpdate()
           enddo

      case ::nAbsTop() == nMRow .and. ;
           ( ::nAbsLeft() + ::nLen + 1 ) == nMCol
           do while lMPressed()
              if ::nAbsTop() == nMRow .and. ;
                 ( ::nAbsLeft() + ::nLen + 1 ) == nMCol
                 ::GoRight()
              endif
              MUpdate()
           enddo
   endcase

return

//----------------------------------------------------------------------------//

METHOD function EdtGoLeft()

   if ::nCrsPos > 1
      ::nCrsPos--
      @ ::nAbsTop(), ::nAbsLeft() + ::nCrsPos SAY ""
   else
      if ::nStartCol > 1
         ::nStartCol--
         ::BufDisplay()
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function EdtGoRight()

   if ::nStartCol + ::nCrsPos - 1 < Len( ::cText ) + 1
      if ::nCrsPos < ::nLen
         ::nCrsPos++
         @ ::nAbsTop(), ::nAbsLeft() + ::nCrsPos SAY ""
      else
         if ::nStartCol < Len( ::cText ) - ::nLen + 1
            ::nStartCol++
            ::BufDisplay()
         endif
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function EdtBufDisplay()

   local nMCrsOld := SetMCursor()

   SetMCursor( 0 )
   SetCursor( 0 )

   @ ::nAbsTop(), ::nAbsLeft() SAY If( ::nStartCol > 1, Chr( 17 ), " " ) ;
     COLOR If( ::nStartCol > 1, "BG+/B", ::cClrNormal )
   @ ::nAbsTop(), ::nAbsLeft() + ::nLen + 1 SAY ;
     If( Len( ::cText ) - ::nStartCol > ::nLen - 1, Chr( 16 ),;
     " " ) COLOR If( Len( ::cText ) - ::nStartCol > ::nLen - 1,;
     "BG+/B", ::cClrNormal )

   @ ::nAbsTop(), ::nAbsLeft() + 1 ;
     SAY SubStr( ::cText, ::nStartCol, ::nLen ) ;
     COLOR If( ::lFocused, ::cClrFocus, ::cClrNormal )
   if Len( ::cText ) - ::nStartCol < ::nLen
      @ ::nAbsTop(), ::nAbsLeft() + 2 + Len( ::cText ) - ::nStartCol ;
        SAY Space( ::nLen - 1 - ;
            ( Len( ::cText ) - ::nStartCol ) ) ;
        COLOR ::cClrNormal
   endif
   if ::lFocused
      @ ::nAbsTop(), ::nAbsLeft() + ::nCrsPos SAY ""
      SetCursor( If( ::lInsert, 2, 1 ) )
   endif
   SetMcursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function EdtClear()

   ::cText     = ""
   ::nCrsPos   = 1
   ::nStartCol = 1
   ::nBlkStart = 0
   ::nBlkEnd   = 0
   ::BufDisplay()
   ::oParent:EdtChanged( Self )

return

//----------------------------------------------------------------------------//

METHOD function EdtSetText( cText )

   ::cText     = SubStr( cText, 1, ::nMaxLen )
   ::nCrsPos   = 1
   ::nStartCol = 1
   ::nBlkStart = 0
   ::nBlkEnd   = 0
   ::BufDisplay()
   ::oParent:EdtChanged( Self )

return

//----------------------------------------------------------------------------//

METHOD function cEdtGetHotKey()

return If( ::oLabel != nil, ::oLabel:cGetHotKey(), "" )

//----------------------------------------------------------------------------//
