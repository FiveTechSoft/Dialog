#include "dialog.ch"

#define ID_nTIPO   100
#define ID_nUNIDAD 200
#define ID_nOK     300
#define ID_nCANCEL 400

//----------------------------------------------------------------------------//

function Main()

   local dlgDrive := DlgDrive():New()

   SetColor( "w+/b" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   Alert( dlgDrive:cExec() )
   dlgDrive:Hide()

return nil

//----------------------------------------------------------------------------//

CLASS DlgDrive FROM Dialog

   VAR rbmLogical
   VAR lbxDrives
   VAR pbtOk, pbtCancel
   VAR cResult

   METHOD New           = DdrNew
   METHOD PbtClick      = DdrPbtClick
   METHOD CtrlGotFocus  = DdrCtrlGotFocus
   METHOD CtrlLostFocus = DdrCtrlLostFocus
   METHOD cExec         = cDdrExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DdrNew()

   ::Parent:New( 6, 23, 18, 53, " Elija Unidad " )

   ::rbmLogical = RbMenu():New( 2, 3, "&Tipo", ID_nTIPO,;
                                " Elija el tipo adecuado " )
   ::lbxDrives  = ListBox():New( 6, 3, 10, 15, "&Unidades", ID_nUNIDAD,;
                                 " Seleccione la unidad deseada " )
   ::pbtOk      = PushButton():New( 3, 19, "   &Ok   ", ID_nOK, " De Acuerdo " )
   ::pbtCancel  = PushButton():New( 5, 19, " &Cancel ", ID_nCANCEL, " Cancelar " )
   ::cResult    = ""

   ::rbmLogical:AddItem( "&F¡sicas " )
   ::rbmLogical:AddItem( "&L¢gicas " )

   ::lbxDrives:acItems = Array( nLogDrives() )
   AEval( ::lbxDrives:acItems,;
      { | cItem, n | ::lbxDrives:acItems[ n ] := "  " + Chr( n + 64 ) + ":" } )

   ::pbtOk:lDefault = .t.

   ::AddControl( ::rbmLogical )
   ::AddControl( ::lbxDrives )
   ::AddControl( ::pbtOk )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DdrPbtClick( Pbt )

   if Pbt:nId == ID_nOK
      ::lEndExec = .t.
      ::cResult = ::lbxDrives:acItems[ ::lbxDrives:nOption ]
   else
      ::cResult = ""
      ::EndExec()
   endif

return

//----------------------------------------------------------------------------//

METHOD function DdrCtrlGotFocus( oControl )

   do case
      case oControl:nId == ID_nCANCEL
           ::pbtOk:lDefault = .f.
           ::pbtOk:Display()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DdrCtrlLostFocus( oControl )

   do case
      case oControl:nId == ID_nCANCEL
           ::pbtOk:lDefault = .t.
           ::pbtOk:Display()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function cDdrExec()

   ::Exec()

return ::cResult

//----------------------------------------------------------------------------//
