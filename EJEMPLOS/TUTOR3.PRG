// Compilar: CLIPPER tutor3.prg /n
// Enlazar:  RTlink fi tutor3 lib Dialog

#include "dialog.ch"

#define ID_nVALORES 100
#define ID_nOK      200
#define ID_nCANCEL  300

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTest():New()

   SetCancel( .f. )
   SetCursor( 0 )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgTest:Exec()
   @ 4, 15 SAY "Seleccion¢: " + dlgTest:cResult
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR pbtOk, pbtCancel
   VAR lbxValores
   VAR cResult

   METHOD New           = DtsNew
   METHOD PbtClick      = DtsPbtClick
   METHOD CtrlGotFocus  = DtsCtrlGotFocus

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 6, 15, 17, 65, "Seleccione" )
   ::pbtOk      = PushButton():New( 3, 39,   "   &Ok   ", ID_nOK,;
                                    " De Acuerdo " )
   ::pbtCancel  = PushButton():New( 6, 39, " &Cancel ", ID_nCANCEL,;
                                    " Cancelar " )
   ::lbxValores = ListBox():New( 3, 4, 8, 35, "&Valores", ID_nVALORES,;
                                 " Elija un valor " )
   ::cResult    = ""

   ::pbtOk:lDefault     = .t.
   ::lbxValores:acItems = { " Uno ", " Dos ", " Tres ", " Cuatro ", " Cinco " }

   ::AddControl( ::lbxValores )
   ::AddControl( ::pbtOk )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DtsPbtClick( oPbt )

   do case
      case oPbt:nId == ID_nOK
           ::Say( 10, 18, "Ha pulsado Ok    " )
           ::cResult = ::lbxValores:acItems[ ::lbxValores:nOption ]
           ::EndExec()

      case oPbt:nId == ID_nCANCEL
           ::Say( 10, 18, "Ha pulsado Cancel" )
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DtsCtrlGotFocus( oControl )

   do case
      case oControl:nId == ID_nVALORES
           if ! ::pbtOk:lDefault
              ::pbtOk:lDefault     = .t.
              ::pbtCancel:lDefault = .f.
              ::pbtOk:Display()
              ::pbtCancel:Display()
           endif

      case oControl:nId == ID_nCANCEL
           if ::pbtOk:lDefault
              ::pbtOk:lDefault = .f.
              ::pbtOk:Display()
           endif
   endcase

return

//----------------------------------------------------------------------------//
