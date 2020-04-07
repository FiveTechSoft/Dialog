#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS Menu FROM Visual

   VAR aItems
   VAR nOption

   METHOD New        = MnuNew
   METHOD Display    = MnuDisplay
   METHOD Hide       = MnuHide
   METHOD Click      = MnuClick
   METHOD KeyPressed = MnuKey
   METHOD SetOption  = MnuSetOption
   METHOD GoTop      = MnuGoTop
   METHOD GoBottom   = MnuGoBottom
   METHOD GoUp       = MnuGoUp
   METHOD GoDown     = MnuGoDown
   METHOD GoLeft     = MnuGoLeft
   METHOD GoRight    = MnuGoRight
   METHOD SetColor   = MnuSetColor
   METHOD nExec      = nMnuExec
   METHOD AddItem    = MnuAddItem
   METHOD SetFocus   = MnuSetFocus
   METHOD lIsOver    = lMnuIsOver
   METHOD cGetHotKey = cMnuGetHotKey
   METHOD nHotAt     = nMnuHotAt

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function MnuNew()

   ::Parent:New()

   ::aItems     = {}
   ::nOption    = 0
   ::cClrNormal = "N/BG"
   ::cClrFocus  = "W+/N"

return Self

//----------------------------------------------------------------------------//

METHOD function MnuDisplay()

   AEval( ::aItems, { | oItem | oItem:Show() } )

return

//----------------------------------------------------------------------------//

METHOD function MnuHide()

   if ::nOption != 0
      ::aItems[ ::nOption ]:SetFocus( .f., ::cClrFocus )
   endif
   AEval( ::aItems, { | oItem | oItem:Hide() } )
   ::Parent:Hide()
   ::nOption = 0

return

//----------------------------------------------------------------------------//

METHOD function MnuClick( nRow, nCol )

   local nAt

   do while lMPressed()
      nAt := AScan( ::aItems, { | oItem | oItem:lIsOver( nRow, nCol ) } )
      if nAt != 0 .and. nAt != ::nOption
         ::SetOption( nAt )
      endif
      MUpdate()
      nRow = nMRow()
      nCol = nMCol()
   enddo

return

//----------------------------------------------------------------------------//

METHOD function MnuKey( nKey )

   local nHotAt

   do case
      case nKey == K_ESC
           ::aItems[ ::nOption ]:SetFocus( .f., ::cClrFocus )
           ::nOption  = 0
           ::lEndExec = .t.

      case nKey == K_ENTER
           ::lEndExec = .t.

      case nKey == K_LEFT
           ::GoLeft()

      case nKey == K_RIGHT
           ::GoRight()

      case nKey == K_UP
           ::GoUp()

      case nKey == K_DOWN
           ::GoDown()

      case nKey == K_HOME
           ::GoTop()

      case nKey == K_END
           ::GoBottom()

      case ( nHotAt := ::nHotAt( Chr( nKey ) ) ) != ::nOption
           if nHotAt != 0
              ::SetOption( nHotAt )
           endif
   endcase

return

//----------------------------------------------------------------------------//

METHOD function MnuSetOption( nNewOption )

   if ::nOption != nNewOption
      if ::nOption != 0
         ::aItems[ ::nOption ]:SetFocus( .f. )
      endif
      ::nOption = nNewOption
      if ::nOption != 0
         ::aItems[ ::nOption ]:SetFocus( .t., ::cClrFocus )
         if ::oParent != nil
            ::oParent:MnuSelect( Self )
         endif
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuGoTop()

   ::SetOption( 1 )

return

//----------------------------------------------------------------------------//

METHOD function MnuGoBottom()

   ::SetOption( Len( ::aItems ) )

return

//----------------------------------------------------------------------------//

METHOD function MnuGoUp()

   if ::nOption == 1
      ::SetOption( Len( ::aItems ) )
   else
      ::SetOption( ::nOption - 1 )
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuGoDown()

   if ::nOption == Len( ::aItems )
      ::SetOption( 1 )
   else
      ::SetOption( ::nOption + 1 )
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuGoLeft()

   if ::nOption == 1
      ::SetOption( Len( ::aItems ) )
   else
      ::SetOption( ::nOption - 1 )
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuGoRight()

   if ::nOption == Len( ::aItems )
      ::SetOption( 1 )
   else
      ::SetOption( ::nOption + 1 )
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuSetColor( cClrNormal, cClrFocus )

   ::cClrNormal = cClrNormal
   ::cClrFocus  = cClrFocus

   AEval( ::aItems,;
   { | oItem | ;
     oItem:cClrNormal := ::cClrNormal, oItem:cClrFocus := ::cClrFocus } )

return

//----------------------------------------------------------------------------//

METHOD function nMnuExec()

   ::Exec()

return ::nOption

//----------------------------------------------------------------------------//

METHOD function MnuAddItem( oItem )

   AAdd( ::aItems, oItem )
   oItem:oParent = Self
   if ::oParent != nil
      ::oParent:MnuChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function MnuSetFocus( lOnOff, cClrFocus )

   ::Parent:SetFocus( lOnOff, cClrFocus )
   if lOnOff
      if ::nOption == 0
         ::SetOption( 1 )
      else
         ::aItems[ ::nOption ]:SetFocus( .t., ::cClrFocus )
      endif
   else
      ::aItems[ ::nOption ]:SetFocus( .f. )
   endif

return

//----------------------------------------------------------------------------//

METHOD function lMnuIsOver( nRow, nCol )

return AScan( ::aItems, { | oItem | oItem:lIsOver( nRow, nCol ) } ) != 0

//----------------------------------------------------------------------------//

METHOD function cMnuGetHotKey()

return ""

//----------------------------------------------------------------------------//

METHOD function nMnuHotAt( cHotKey )

   cHotKey = Upper( cHotKey )

return If( Len( ::aItems ) != 0,;
       AScan( ::aItems, { | oItem | Upper( oItem:cGetHotKey() ) == cHotKey } ),;
       0 )

//----------------------------------------------------------------------------//
