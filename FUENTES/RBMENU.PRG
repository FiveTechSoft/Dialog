#include "dialog.ch"

//----------------------------------------------------------------------------//

CLASS RbMenu FROM Menu

   VAR oLabel
   VAR lHorizontal

   METHOD New        = RbmNew
   METHOD AddItem    = RbmAddItem
   METHOD Display    = RbmDisplay
   METHOD Hide       = RbmHide
   METHOD lIsOver    = lRbmIsOver
   METHOD SetFocus   = RbmSetFocus
   METHOD SetOption  = RbmSetOption
   METHOD cGetHotKey = cRbmGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function RbmNew( nRow, nCol, cLabel, nId, cMessage, lHorizontal )

   DEFAULT nRow = 0,  nCol = 0, cLabel = "&RbMenu", nId  = 0,;
           lHorizontal = .f.

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
   ::cClrFocus       = "W+/N"
   ::nOption         = 1

return Self

//----------------------------------------------------------------------------//

METHOD function RbmAddItem( cText )

   local oLastItem := ATail( ::aItems )
   local oNewItem  := RadioBtn():New( 0, 0, cText, 0 )
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

   oNewItem:cClrFocus = ::cClrFocus
   oNewItem:cMessage  = nil
   ::Parent:AddItem( oNewItem )

   if Len( ::aItems ) == 1
      ::aItems[ 1 ]:lChecked = .t.
   endif

   if ! ::lHorizontal
      AEval( ::aItems,;
          { | oItem | nMaxWidth := Max( nMaxWidth, nLabelLen( oItem:cText ) ) } )
      AEval( ::aItems,;
          { | oItem | oItem:SetText( PadR( oItem:cText, nMaxWidth + ;
          If( At( "&", oItem:cText ) != 0, 1, 0 ) ) ) } )
   endif

return

//----------------------------------------------------------------------------//

METHOD function RbmDisplay()

   if ::oLabel != nil
      ::oLabel:Show()
   endif
   ::Parent:Display()

return

//----------------------------------------------------------------------------//

METHOD function RbmHide()

   if ::oLabel != nil
      ::oLabel:Hide()
   endif
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function lRbmIsOver( nRow, nCol )

   local lIsOver := If( ::oLabel != nil, ::oLabel:lIsOver( nRow, nCol ), .f. )

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function RbmSetFocus( lOnOff, cClrFocus )

   if ::oLabel != nil
      ::oLabel:SetFocus( lOnOff, cClrFocus )
   endif

   ::Parent:SetFocus( lOnOff, cClrFocus )

return

//----------------------------------------------------------------------------//

METHOD function RbmSetOption( nOption )

   local nOptOld := ::nOption

   if ::nOption != nOption .and. ::nOption != 0
      ::aItems[ ::nOption ]:lChecked = .f.
      ::aItems[ ::nOption ]:SetFocus( .f., ::cClrFocus )
   endif
   ::nOption = nOption
   if ::nOption != 0
      ::aItems[ ::nOption ]:lChecked = .t.
      ::aItems[ ::nOption ]:SetFocus( ::lFocused, ::cClrFocus )
   endif

   if nOptOld != ::nOption
      if ::oParent != nil
         ::oParent:RbmChanged( Self )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function cRbmGetHotKey()

return If( ::oLabel != nil, ::oLabel:cGetHotKey(), "" )

//----------------------------------------------------------------------------//
