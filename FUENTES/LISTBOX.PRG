#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS ListBox FROM Visual

   VAR acItems
   VAR nOption
   VAR nFirstRow
   VAR cClrDataFocus, cClrOption
   VAR oLabel
   VAR oScrBar

   METHOD New        = LbxNew
   METHOD Display    = LbxDisplay
   METHOD Hide       = LbxHide
   METHOD SetFocus   = LbxSetFocus
   METHOD Hilite     = LbxHilite
   METHOD Dehilite   = LbxDeHilite
   METHOD KeyPressed = LbxKeyPressed
   METHOD Click      = LbxClick
   METHOD DblClick   = LbxDblClick
   METHOD lIsOver    = lLbxIsOver
   METHOD GoUp       = LbxGoUp
   METHOD GoDown     = LbxGoDown
   METHOD GoTop      = LbxGoTop
   METHOD GoBottom   = LbxGoBottom
   METHOD PgUp       = LbxPgUp
   METHOD PgDn       = LbxPgDn
   METHOD SbrUp      = LbxSbrUp
   METHOD SbrDown    = LbxSbrDown
   METHOD SbrPgUp    = LbxSbrPgUp
   METHOD SbrPgDown  = LbxSbrPgDn
   METHOD AddItem    = LbxAddItem
   METHOD SetItems   = LbxSetItems
   METHOD Delete     = LbxDelete
   METHOD cGetHotKey = cLbxGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function LbxNew( nTop, nLeft, nBottom, nRight, cLabel, nId, cMessage )

   DEFAULT nTop = 0, nLeft = 0, nBottom = 3, nRight = 10, cLabel = "&ListBox",;
           nId = 0, cMessage = ""

   ::Parent:New()

   ::nTop             = nTop
   ::nLeft            = nLeft
   ::nBottom          = nBottom
   ::nRight           = nRight
   ::acItems          = {}
   ::nOption          = 1
   ::nFirstRow        = 1
   ::cClrDataFocus    = "W+/N"
   ::cClrOption       = "BG+/BG"
   ::cClrNormal       = "N/BG"
   ::nId              = nId
   ::cMessage         = cMessage
   ::oLabel           = Label():New( -1, 0, cLabel )
   ::oLabel:cMessage  = nil
   ::oLabel:oParent   = Self
   ::oScrBar          = ScrollBar():New( 0, nRight - nLeft, nBottom - nTop + 1 )
   ::oScrBar:oLabel   = nil
   ::oScrBar:cMessage = nil
   ::oScrBar:oParent  = Self

return Self

//----------------------------------------------------------------------------//

METHOD function LbxDisplay()

   local nMCrsOld := SetMCursor()
   local n := 0, nItems := Len( ::acItems )
   local nRows  := ::nBottom - ::nTop + 1
   local nWidth := ::nRight - ::nLeft

   if ::oLabel != nil
      ::oLabel:Show()
   endif
   SetMCursor( 0 )
   @ ::nAbsTop(), ::nAbsLeft(), ::nAbsTop() + nRows - 1,;
     ::nAbsLeft() + nWidth - 1 BOX "         " COLOR ::cClrNormal
   ::oScrBar:nRange = Len( ::acItems )
   ::oScrBar:nValue = ::nOption
   ::oScrBar:Show()
   do while n < nRows .and. n < nItems
      @ ::nAbsTop() + n, ::nAbsLeft() ;
        SAY PadR( ::acItems[ n + ::nFirstRow ], nWidth ) ;
        COLOR ::cClrNormal
      n++
   enddo
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function LbxHide()

   if ::oLabel != nil
      ::oLabel:Hide()
   endif
   if ::oScrBar != nil
      ::oScrBar:Hide()
   endif
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function LbxSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   if ::oLabel != nil
      ::oLabel:SetFocus( lOnOff, cClrFocus )
   endif
   ::oScrBar:SetFocus( lOnOff, cClrFocus )
   if lOnOff
      ::Hilite()
   else
      ::Dehilite( ::cClrOption )
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxKeyPressed( nKey )

   do case
      case nKey == K_ESC
           ::DeHilite( ::cClrNormal )
           ::nOption = 0
           ::EndExec()

      case nKey == K_ENTER
           if ::oParent != nil
              ::oParent:LbxChoosed( Self )
           else
              ::EndExec()
           endif

      case nKey == K_DOWN
           ::GoDown()

      case nKey == K_UP
           ::GoUp()

      case nKey == K_HOME
           ::GoTop()

      case nKey == K_END
           ::GoBottom()

      case nKey == K_PGUP
           ::PgUp()

      case nKey == K_PGDN
           ::PgDn()

   endcase

return

//----------------------------------------------------------------------------//

METHOD function LbxClick( nMRow, nMCol )

   local nNewOption

   do case
      case ::oScrBar:lIsOver( nMRow, nMCol )
           ::oScrBar:Click( nMRow, nMCol )

      case ! ::Parent:lIsOver( nMRow, nMCol )

      otherwise
           do while lMPressed()
              if ::Parent:lIsOver( nMRow, nMCol ) .and. ;
                 ( nNewOption := nMRow - ::nAbsTop() + ::nFirstRow ) ;
                 != ::nOption .and. nNewOption > 0 .and. ;
                 nNewOption <= Len( ::acItems )

                 ::DeHilite( ::cClrNormal )
                 ::nOption = nNewOption
                 ::oScrBar:nValue = ::nOption
                 ::oScrBar:ThmCheck()
                 if ::oParent != nil
                    ::oParent:LbxSelect( Self )
                 endif
                 ::Hilite()
              else
                 do case
                    case nMRow < ::nAbsTop()
                         ::GoUp()

                    case nMRow > ::nAbsTop() + ::nBottom - ::nTop
                         ::GoDown()
                 endcase
              endif
              MUpdate()
              nMRow = nMRow()
              nMCol = nMCol()
           enddo
   endcase

return

//----------------------------------------------------------------------------//

METHOD function LbxDblClick( nMRow, nMCol )

   local nSelected

   if ::Parent:lIsOver( nMRow, nMCol )  .and. ;
      ! ::oScrBar:lIsOver( nMRow, nMCol ) .and. ;
      ( nSelected := nMRow - ::nAbsTop() + ::nFirstRow ) > 0 .and. ;
      nSelected <= Len( ::acItems )

      if ::oParent != nil
         ::oParent:LbxChoosed( Self )
      else
         ::EndExec()
      endif

   endif

return

//----------------------------------------------------------------------------//

METHOD function lLbxIsOver( nRow, nCol )

   local lIsOver := If( ::oLabel != nil, ::oLabel:lIsOver( nRow, nCol ), .f. )

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function LbxGoUp()

   local nMOldCursor := SetMCursor()

   if ::nOption > 1
      ::DeHilite( ::cClrNormal )
      ::nOption--
      if ::nOption < ::nFirstRow
         SetMCursor( 0 )
         Scroll( ::nAbsTop(),;
                 ::nAbsLeft(),;
                 ::nAbsTop() + ::nBottom - ::nTop,;
                 ::nAbsLeft() + ::nRight - ::nLeft - 1,;
                 -1 )
         SetMCursor( nMOldCursor )
         ::nFirstRow--
      endif
      ::Hilite()
      ::oScrBar:nValue = ::nOption
      ::oScrBar:ThmCheck()
      if ::oParent != nil
         ::oParent:LbxSelect( Self )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxGoDown()

   local nRows := ::nBottom - ::nTop + 1
   local nMOldCursor := SetMCursor()

   if ::nOption < Len( ::acItems )
      ::DeHilite( ::cClrNormal )
      ::nOption++
      if ::nOption - ::nFirstRow == nRows
         SetMCursor( 0 )
         Scroll( ::nAbsTop(),;
                 ::nAbsLeft(),;
                 ::nAbsTop() + ::nBottom - ::nTop,;
                 ::nAbsLeft() + ::nRight - ::nLeft - 1,;
                 1 )
         SetMCursor( nMOldCursor )
         ::nFirstRow++
      endif
      ::Hilite()
      ::oScrBar:nValue = ::nOption
      ::oScrBar:ThmCheck()
      if ::oParent != nil
         ::oParent:LbxSelect( Self )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxPgDn()

   local nRows  := ::nBottom - ::nTop + 1
   local nItems  := Len( ::acItems )

   if ::nOption < nItems
      ::Dehilite( ::cClrNormal )
      if nItems - ::nOption < nRows                // Est  en la £ltima pantalla
         if ::nFirstRow != Max( nItems - ( nRows - 1 ), 1 )  // No est  mostrada completa
            ::nFirstRow = Max( nItems - ( nRows - 1 ), 1 )
            ::Display()
         else
            ::nOption = nItems
            ::oScrBar:nValue = ::nOption
            ::oScrBar:ThmCheck()
            if ::oParent != nil
               ::oParent:LbxSelect( Self )
            endif
         endif
      else                                    // No est  en la £ltima pantalla
         ::nOption += nRows
         ::nFirstRow = ::nOption
         if nItems - ::nOption < nRows     // Est  ya en la £ltima
            ::nOption = nItems - ( nRows - 1 )  // primera l¡nea £ltima pantalla
            ::nFirstRow = ::nOption
         endif
         ::oScrBar:nValue = ::nOption
         ::oScrBar:ThmCheck()
         ::Display()
         if ::oParent != nil
            ::oParent:LbxSelect( Self )
         endif
      endif
      ::Hilite()
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxHilite()

   local nWidth := ::nRight - ::nLeft
   local nMOldCursor := SetMCursor()

   if Len( ::acItems ) != 0
      SetMCursor( 0 )
      @ ::nAbsTop() + ( ::nOption - ::nFirstRow ), ::nAbsLeft() ;
        SAY PadR( ::acItems[ ::nOption ], nWidth ) ;
        COLOR ::cClrDataFocus
      SetMCursor( nMOldCursor )
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxDeHilite( cColor )

   local nWidth := ::nRight - ::nLeft
   local nMOldCursor := SetMCursor()

   if Len( ::acItems ) != 0
      SetMCursor( 0 )
      @ ::nAbsTop() + ( ::nOption - ::nFirstRow ), ::nAbsLeft() ;
        SAY PadR( ::acItems[ ::nOption ], nWidth ) ;
        COLOR cColor
      SetMCursor( nMOldCursor )
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxPgUp()

   local nRows := ::nBottom - ::nTop + 1

   if ::nOption > 1
      ::Dehilite( ::cClrNormal )
      if ::nOption <= nRows             // Est  en la primera pantalla
         if ::nFirstRow != 1            // No est  mostrada la
            ::nFirstRow = 1
            ::Display()
         else
            ::nOption = 1
            ::oScrBar:nValue = 1
            ::oScrBar:ThmCheck()
            if ::oParent != nil
               ::oParent:LbxSelect( Self )
            endif
         endif
      else                              // No est  en la primera pantalla
         ::nOption -= ( nRows - 1 )
         ::nFirstRow = ::nOption - ( nRows - 1 )
         if ::nOption < nRows            // Est  ya en la primera
            ::nOption = nRows            // £ltima l¡nea primera pantalla
            ::nFirstRow = 1
          endif
         ::oScrBar:nValue = ::nOption
         ::oScrBar:ThmCheck()
         ::Display()
         if ::oParent != nil
            ::oParent:LbxSelect( Self )
         endif
      endif
      ::Hilite()
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxGoTop()

   if ::nOption != 1
      ::DeHilite( ::cClrNormal )
      ::nOption = 1
      if ::nFirstRow != 1
         ::nFirstRow = 1
         ::Display()
      endif
      ::oScrBar:nValue = ::nOption
      ::oScrBar:ThmCheck()
      if ::oParent != nil
         ::oParent:LbxSelect( Self )
      endif
      ::Hilite()
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxGoBottom()

   local nItems  := Len( ::acItems )
   local nRows := ::nBottom - ::nTop + 1

   if nItems > 0
      if ::nOption != nItems
         ::DeHilite( ::cClrNormal )
         ::nOption  = nItems
         if ::nFirstRow != Max( nItems - ( nRows - 1 ), 1 )
            ::nFirstRow = Max( nItems - ( nRows - 1 ), 1 )
            ::Display()
         endif
         ::oScrBar:nValue = ::nOption
         ::oScrBar:ThmCheck()
         if ::oParent != nil
            ::oParent:LbxSelect( Self )
         endif
         ::Hilite()
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxSbrUp()

   ::GoUp()

return

//----------------------------------------------------------------------------//

METHOD function LbxSbrDown()

   ::GoDown()

return

//----------------------------------------------------------------------------//

METHOD function LbxSbrPgUp()

   ::PgUp()

return

//----------------------------------------------------------------------------//

METHOD function LbxSbrPgDn()

   ::PgDn()

return

//----------------------------------------------------------------------------//

METHOD function LbxAddItem( cItem )

   AAdd( ::acItems, cItem )
   if ::oParent != nil
      ::oParent:LbxChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxSetItems( acItems )

   ::acItems        = acItems
   ::nOption        = 1
   ::nFirstRow      = 1
   ::oScrBar:nValue = 1
   ::oScrBar:nRange = Len( ::acItems )
   ::oScrBar:ThmCheck()
   ::Display()
   if ::oParent != nil
      ::oParent:LbxChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function LbxDelete( nItem )

   if Len( ::acItems ) > 0 .and. nItem <= Len( ::acItems )
      ADel( ::acItems, nItem )
      ASize( ::acItems, Len( ::acItems ) - 1 )
      ::nOption = Min( ::nOption, Len( ::acItems ) )
      ::oScrBar:nValue = ::nOption
      ::oScrBar:nRange = Len( ::acItems )
      ::oScrBar:ThmCheck()
      if ::oParent != nil
         ::oParent:LbxChanged( Self )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function cLbxGetHotKey()

return If( ::oLabel != nil, ::oLabel:cGetHotKey, "" )

//----------------------------------------------------------------------------//
