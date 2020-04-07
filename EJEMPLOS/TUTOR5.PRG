#include "dialog.ch"

#define ID_nPERMITE 100
#define ID_nOFRECE  200
#define ID_nINCLUYE 300
#define ID_nHAYMAS  400
#define ID_nPIDE    500
#define ID_nDIALOG  600
#define ID_nYA      700

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTest():New()

   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR cbmPermite, cbmIncluye
   VAR lbxOfrece
   VAR rbmHayMas
   VAR pbtPide, pbtDialog, pbtYa

   METHOD New = DtsNew

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 2, 3, 20, 75, "Dialog ver. 1.00 para Clipper 5" )

   ::cbmPermite = CbMenu():New( 2, 4, "Te &Permite", ID_nPERMITE,;
                  " Usa Tab, Shift-Tab ¢ Alt-HotKey para siguiente grupo " )
   ::lbxOfrece  = ListBox():New( 7, 4, 12, 52, "Te &Ofrece", ID_nOFRECE,;
                  " ­­­ Usala con rat¢n !!! " )
   ::cbmIncluye = CbMenu():New( 15, 4, "Adem s &Incluye", ID_nINCLUYE,;
                  " Pulsa Espacio ¢ Enter para conmutar los CheckButtons " )
   ::rbmHayMas  = RbMenu():New( 2, 50, "&Y a£n hay m s...", ID_nHAYMAS,;
                  " Con Dialog puedes ya usar OOPS al 100% " )
   ::pbtPide    = PushButton():New(  9, 58, "  Pid&e  ", ID_nPIDE,;
                  " Te aseguro que te va a encantar! " )
   ::pbtDialog  = PushButton():New( 12, 58, " Dia&log ", ID_nDIALOG,;
                  " No esperes m s " )
   ::pbtYa      = PushButton():New( 15, 58, " Y&a!!!  ", ID_nYA,;
                  " Entra en el fascinante mundo del OOPS " )

   ::cbmPermite:AddItem( "&Creaci¢n de sofisticadas Cajas " )
   ::cbmPermite:AddItem( "de &Di logo c¢mo esta que est s " )
   ::cbmPermite:AddItem( "&usando ahora, ­ en s¢lo unos minutos !" )

   ::cbmPermite:aItems[ 1 ]:lChecked = .t.
   ::cbmPermite:aItems[ 2 ]:lChecked = .t.
   ::cbmPermite:aItems[ 3 ]:lChecked = .t.

   ::lbxOfrece:acItems = { " Entender a fondo y usar ya el OOPS ",;
                           " ( OOPS = Programaci¢n Orientada al Objeto ). ",;
                           " Dialog est  construida 100% sobre tecnolog¡a ",;
                           " Orientada al Objeto y... contiene todo el ",;
                           " c¢digo fuente !!! ",;
                           " Y no s¢lo eso... ",;
                           " Entender s que es la tecnolog¡a Event-Driven ",;
                           " ( Sistemas conducidos por Eventos ) ",;
                           " C¢mo se usa, c¢mo se programa! y las ventajas ",;
                           " que aporta.",;
                           " ¨ Que esperas ? Pide Dialog ya !!! " }

   ::cbmIncluye:AddItem( "­ &Todo el c¢digo fuente !" )
   ::cbmIncluye:AddItem( "Una gu¡a &Norton con muchas explicaciones" )
   ::cbmIncluye:AddItem( "&Un Tutorial completo para aprender a usarla " )

   ::cbmIncluye:aItems[ 1 ]:lChecked = .t.
   ::cbmIncluye:aItems[ 2 ]:lChecked = .t.
   ::cbmIncluye:aItems[ 3 ]:lChecked = .t.

   ::rbmHayMas:AddItem( "&Puedes crear" )
   ::rbmHayMas:AddItem( "nuevas &Clases " )
   ::rbmHayMas:AddItem( "y O&bjetos ya!"  )

   ::pbtYa:cClrNormal = "N/RB"
   ::pbtYa:cClrHotKey = "GR+/RB"

   ::AddControl( ::cbmPermite )
   ::AddControl( ::lbxOfrece )
   ::AddControl( ::cbmIncluye )
   ::AddControl( ::rbmHayMas )
   ::AddControl( ::pbtPide )
   ::AddControl( ::pbtDialog )
   ::AddControl( ::pbtYa )

return Self

//----------------------------------------------------------------------------//
