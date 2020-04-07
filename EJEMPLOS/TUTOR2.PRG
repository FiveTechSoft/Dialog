// Compilar: CLIPPER tutor2.prg /n
// Enlazar:  RTlink fi tutor2 lib Dialog

#include "dialog.ch"

#define ID_nHOLA    100
#define ID_nADIOS   200
#define ID_nMEGUSTA 300

//----------------------------------------------------------------------------//

function Main()

   local dlgTest    := Dialog():New( 7, 22, 15, 54, "Bienvenido" )
   local pbtHola    := PushButton():New( 2, 2, " &Hola  ", ID_nHOLA,;
     " Usa Tab ¢ el rat¢n ¢ Alt+HotKey para pasar al siguiente control... " )
   local pbtAdios   := PushButton():New( 5, 2, " &Adios ", ID_nADIOS,;
                                         " ¨ Te vas ? " )
   local cbtMeGusta := CheckBtn():New( 4, 10, "&Me gusta Dialog", ID_nMEGUSTA,;
                                       " Oye, esto est  bien! " )

   SetCursor( 0 )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgTest:AddControl( pbtHola )
   dlgTest:AddControl( pbtAdios )
   dlgTest:AddControl( cbtMeGusta )

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//
