#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS CbMenu FROM Menu

   VAR oLabel
   VAR lHorizontal

   METHOD New        = CbmNew
   METHOD AddItem    = CbmAddItem
   METHOD Display    = CbmDisplay
   METHOD Hide       = CbmHide
   METHOD lIsOver    = lCbmIsOver
   METHOD SetFocus   = CbmSetFocus
   METHOD KeyPressed = CbmKeyPressed
   METHOD Click      = CbmClick
   METHOD cGetHotKey = cCbmGetHotKey
   METHOD CbtChanged = CbmCbtChanged
   METHOD SetValue   = CbmSetValue

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function CbmNew( nRow, nCol, cLabel, nId, cMessage, lHorizontal )

   DEFAULT nRow = 0, nCol = 0, cLabel = "&CbMenu", nId = 0, lHorizontal = .f.

   ::Parent:New()

   ::nTop            = nRow
   ::nLeft           = nCol
   ::nBottom         = nRow
   ::nRight          = nCol
   ::oLabel          = Label():New( -1, 0, cLabel )
   ::oLabel:cMessage = nil
   ::oLabel:oParent  = Self
   ::nId             = nId
   ::cMessage        = cMessage
   ::lHorizontal     = lHorizontal
   ::cClrNormal      = "N/BG"
   ::cClrFocus       = "W+/N"
   ::nOption         = 1

return Self

//----------------------------------------------------------------------------//

METHOD function CbmAddItem( cText )

   local oLastItem := ATail( ::aItems )
   local oNewItem  := CheckBtn():New( 0, 0, cText, 0 )
   local nMaxWidth := 0

   if ::lHorizontal
      oNewItem:Move( 0,;
                     If( oLastItem != nil,;
                     oLastItem:nLeft + nLabelLen( oLastItem:cText ) + 5, 0 ) )
      ::nRight += nLabelLen( oNewItem:cText )
   else
      oNewItem:Move( If( oLastItem != nil, oLastItem:nTop + 1, 0 ), 0 )
      ::nBottom++
      ::nRight = ::nLeft + Max( ::nRight - ::nLeft,;
                                nLabelLen( oNewItem:cText ) )
   endif

   oNewItem:cClrNormal = "N/BG"
   oNewItem:cClrFocus  = ::cClrFocus
   oNewItem:cMessage   = nil
   ::Parent:AddItem( oNewItem )

   if ! ::lHorizontal
      AEval( ::aItems,;
          { | oItem | nMaxWidth := Max( nMaxWidth, nLabelLen( oItem:cText ) ) } )
      AEval( ::aItems,;
          { | oItem | oItem:SetText( PadR( oItem:cText, nMaxWidth + ;
          If( At( "&", oItem:cText ) != 0, 1, 0 ) ) ) } )
   endif

return

//----------------------------------------------------------------------------//

METHOD function CbmDisplay()

   if ::oLabel != nil
      ::oLabel:Show()
   endif
   ::Parent:Display()

return

//----------------------------------------------------------------------------//

METHOD function CbmHide()

   if ::oLabel != nil
      ::oLabel:Hide()
   endif
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function lCbmIsOver( nRow, nCol )

   local lIsOver := If( ::oLabel != nil, ::oLabel:lIsOver( nRow, nCol ), .f. )

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function CbmSetFocus( lOnOff, cClrFocus )

   if ::oLabel != nil
      ::oLabel:SetFocus( lOnOff, cClrFocus )
   endif
   ::Parent:SetFocus( lOnOff, cClrFocus )

return

//----------------------------------------------------------------------------//

METHOD function CbmKeyPressed( nKey )

   do case
      case nKey == 32 .or. nKey == K_ENTER
           if ::nOption != 0
              ::aItems[ ::nOption ]:KeyPressed( nKey )
           endif

      otherwise
           ::Parent:KeyPressed( nKey )
   endcase

return

//----------------------------------------------------------------------------//

METHOD function CbmClick( nMRow, nMCol )

   ::Parent:Click( nMRow, nMCol )
   if ::nOption != 0
      if ::aItems[ ::nOption ]:lIsOver( nMRow(), nMCol() )
         ::aItems[ ::nOption ]:KeyPressed( 32 )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function cCbmGetHotKey()

return If( ::oLabel != nil, ::oLabel:cGetHotKey(), "" )

//----------------------------------------------------------------------------//

METHOD function CbmCbtChanged( oCheckBtn )

   if ::oParent != nil
      ::oParent:CbmChanged( Self )
   endif

return

//----------------------------------------------------------------------------//

METHOD function CbmSetValue( nItem, lOnOff )

   ::aItems[ nItem ]:lChecked = lOnOff
   ::aItems[ nItem ]:Display()

return

//----------------------------------------------------------------------------//
