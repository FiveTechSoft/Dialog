#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS Dialog FROM Window

   VAR aControls
   VAR nControl

   METHOD New         = DlgNew
   METHOD AddControl  = DlgAddCtrl
   METHOD nAtControl  = nDlgAtCtrl
   METHOD nCtrlHot    = nDlgCtrlHot
   METHOD Click       = DlgClick
   METHOD DblClick    = DlgDblClick
   METHOD Display     = DlgDisplay
   METHOD Hide        = DlgHide
   METHOD KeyPressed  = DlgKeyPressed
   METHOD SetFocus    = DlgSetFocus
   METHOD ChangeFocus = DlgChangeFocus
   METHOD pbtDefault  = pbtDlgDefault
   METHOD LbxSelect   = DlgLbxSelect
   METHOD LbxChanged  = DlgLbxChanged
   METHOD LbxChoosed  = DlgLbxChoosed
   METHOD PbtClick    = DlgPbtClick
   METHOD EdtChanged  = DlgEdtChanged
   METHOD CbtChanged  = DlgCbtChanged
   METHOD RbtChanged  = DlgRbtChanged
   METHOD MnuSelect   = DlgMnuSelect
   METHOD MnuChanged  = DlgMnuChanged
   METHOD CbxSelect   = DlgCbxSelect
   METHOD CbmChanged  = DlgCbmChanged
   METHOD PbmChanged  = DlgPbmChanged
   METHOD RbmChanged  = DlgRbmChanged
   METHOD SbrUp       = DlgSbrUp
   METHOD SbrDown     = DlgSbrDown
   METHOD SbrPgUp     = DlgSbrPgUp
   METHOD SbrPgDown   = DlgSbrPgDown

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DlgNew( nTop, nLeft, nBottom, nRight, cTitle )

   DEFAULT nTop = 10, nLeft = 10, nBottom = 20, nRight = 60, cTitle = ""

   ::Parent:New( nTop, nLeft, nBottom, nRight, cTitle )

   ::aControls = {}
   ::nControl  = 0
   ::cClrFocus = "W+/W"

return Self

//----------------------------------------------------------------------------//

METHOD function DlgAddCtrl( oControl )

   AAdd( ::aControls, oControl )
   oControl:oParent = Self
   if ::nControl == 0
      ::nControl++
   endif

return

//----------------------------------------------------------------------------//

METHOD function nDlgAtCtrl( nRow, nCol )

return AScan( ::aControls,;
              { | oControl | oControl:lIsOver( nRow, nCol ) } )

//----------------------------------------------------------------------------//

METHOD function nDlgCtrlHot( nKey )

return AScan( ::aControls,;
       { | oCtrl | cAlt2Chr( nKey ) == Upper( oCtrl:cGetHotKey ) .and. ;
       oCtrl:lActive } )

//----------------------------------------------------------------------------//

METHOD function DlgKeyPressed( nKey )

   local nAtControl
   local pbtDefault

   do case
      case lKeyAlt() .and. At( Chr( nKey ), "\|@#{[]}" ) == 0
           nAtControl = ::nCtrlHot( nKey )
           if nAtControl != 0 .and. nAtControl != ::nControl
              ::aControls[ ::nControl ]:SetFocus( .f., ::cClrFocus )
              ::nControl = nAtControl
              ::aControls[ ::nControl ]:SetFocus( .t., ::cClrFocus )
              if ::aControls[ ::nControl ]:ClassName() == "PUSHBUTTON"
                 ::aControls[ ::nControl ]:KeyPressed( 32 )
              endif
           endif

      case nKey == K_ESC
           do case
              case Len( ::aControls ) > 0
                   if ::aControls[ ::nControl ]:ClassName() == "COMBOBOX"
                      if ::aControls[ ::nControl ]:lOpened
                         ::aControls[ ::nControl ]:KeyPressed( K_ESC )
                      else
                         ::EndExec()
                      endif
                   else
                      ::EndExec()
                   endif

              otherwise
                   ::EndExec()
           endcase

      case nKey == K_ENTER
           pbtDefault = ::pbtDefault()
           if pbtDefault != nil
              pbtDefault:KeyPressed( K_ENTER )
           else
              ::aControls[ ::nControl ]:KeyPressed( K_ENTER )
           endif

      case nKey == K_TAB
           if Len( ::aControls ) > 1
              ::aControls[ ::nControl ]:SetFocus( .f. )
              ::nControl++
              if ::nControl > Len( ::aControls )
                 ::nControl = 1
              endif
              do while ! ::aControls[ ::nControl ]:lActive
                 ::nControl++
                 if ::nControl > Len( ::aControls )
                    ::nControl = 1
                 endif
              enddo
              ::aControls[ ::nControl ]:SetFocus( .t., "w+/b" )
           endif

      case nKey == K_SH_TAB
           if Len( ::aControls ) > 1
              ::aControls[ ::nControl ]:SetFocus( .f. )
              ::nControl--
              if ::nControl < 1
                 ::nControl = Len( ::aControls )
              endif
              do while ! ::aControls[ ::nControl ]:lActive
                 ::nControl--
                 if ::nControl < 1
                    ::nControl = Len( ::aControls )
                 endif
              enddo
              ::aControls[ ::nControl ]:SetFocus( .t., "w+/b" )
           endif

      otherwise
           if Len( ::aControls ) != 0
              ::aControls[ ::nControl ]:KeyPressed( nKey )
           endif

   endcase

return

//----------------------------------------------------------------------------//

METHOD function DlgSetFocus( lOnOff, cColor )

   ::Parent:SetFocus( lOnOff, cColor )
   if Len( ::aControls ) != 0
      if ! ::aControls[ ::nControl ]:lFocused
         ::aControls[ ::nControl ]:SetFocus( lOnOff, cColor )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function DlgChangeFocus( oControl )

   local nAt := AScan( ::aControls, { | oCtrl | oCtrl == oControl } )

   if nAt != ::nControl
      ::aControls[ ::nControl ]:SetFocus( .f., ::cClrFocus )
      ::nControl = nAt
      ::aControls[ ::nControl ]:SetFocus( .t., ::cClrFocus )
   endif

return

//----------------------------------------------------------------------------//

METHOD function pbtDlgDefault()

   local pbtDefault
   local n := 1

   do while n <= Len( ::aControls ) .and. pbtDefault == nil
      if ::aControls[ n ]:ClassName() == "PUSHBUTTON"
         if ::aControls[ n ]:lActive .and. ::aControls[ n ]:lDefault
            pbtDefault = ::aControls[ n ]
         endif
      endif
      n++
   enddo

return pbtDefault

//----------------------------------------------------------------------------//

METHOD function DlgClick( nRow, nCol )

   local nAt

   if ::lDrag
      ::DragOver()
   else
      if ( nAt := ::nAtControl( nRow, nCol ) ) != 0
         if ::aControls[ nAt ]:lActive
            if nAt != ::nControl
               ::aControls[ ::nControl ]:SetFocus( .f. )
               ::nControl = nAt
               ::aControls[ ::nControl ]:SetFocus( .t., "W+/B" )
            endif
            ::aControls[ ::nControl ]:Click( nRow, nCol )
         endif
      else
         ::Parent:Click( nRow, nCol )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function DlgDblClick( nMRow, nMCol )

   if Len( ::aControls ) > 0
      if ::aControls[ ::nControl ]:lIsOver( nMRow, nMCol )
         ::aControls[ ::nControl ]:DblClick( nMRow, nMCol )
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function DlgDisplay()

   ::Parent:Display()
   if Len( ::aControls ) > 0
      AEval( ::aControls, { | oControl | oControl:Show() } )
   endif

return

//----------------------------------------------------------------------------//

METHOD function DlgHide()

   AEval( ::aControls, { | oControl | oControl:Hide() } )
   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function DlgPbtClick( oPbt )
return

//----------------------------------------------------------------------------//

METHOD function DlgLbxSelect( oLbx )
return

//----------------------------------------------------------------------------//

METHOD function DlgLbxChanged( oLbx )
return

//----------------------------------------------------------------------------//

METHOD function DlgLbxChoosed( oLbx )
return

//----------------------------------------------------------------------------//

METHOD function DlgEdtChanged( oEdt )
return

//----------------------------------------------------------------------------//

METHOD function DlgCbtChanged( oCbt )
return

//----------------------------------------------------------------------------//

METHOD function DlgRbtChanged( oRbt )
return

//----------------------------------------------------------------------------//

METHOD function DlgMnuSelect( oMenu )
return

//----------------------------------------------------------------------------//

METHOD function DlgMnuChanged( oMenu )
return

//----------------------------------------------------------------------------//

METHOD function DlgCbxSelect( oComboBox )
return

//----------------------------------------------------------------------------//

METHOD function DlgCbmChanged( oCbMenu )
return

//----------------------------------------------------------------------------//

METHOD function DlgPbmChanged( oPbMenu )
return

//----------------------------------------------------------------------------//

METHOD function DlgRbmChanged( oRbMenu )
return

//----------------------------------------------------------------------------//

METHOD function DlgSbrUp( oScrollBar )
return

//----------------------------------------------------------------------------//

METHOD function DlgSbrDown( oScrollBar )
return

//----------------------------------------------------------------------------//

METHOD function DlgSbrPgUp( oScrollBar )
return

//----------------------------------------------------------------------------//

METHOD function DlgSbrPgDown( oScrollBar )
return

//----------------------------------------------------------------------------//
