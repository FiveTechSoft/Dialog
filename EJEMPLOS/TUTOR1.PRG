// Compilar: CLIPPER tutor1.prg /n
// Enlazar:  RTlink fi tutor1 lib Dialog

#include "dialog.ch"

//----------------------------------------------------------------------------//

function Main()

   local wndTest := Window():New( 10, 10, 20, 40, "Ejemplo" )

   SetCursor( 0 )
   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   wndTest:cClrNormal = "W+/BG"
   wndTest:Show()
   wndTest:SetFocus( .t., "W+/BG" )
   wndTest:Say( 2, 2, "Bienvenido al fascinante" )
   wndTest:Say( 3, 2, "mundo del OOPS !" )
   wndTest:Say( 5, 2, "Pulsa una tecla..." )
   InKey( 0 )
   wndTest:Move( 3, 3 )
   wndTest:Say( 5, 2, "Pulsa una tecla..." )
   InKey( 0 )
   wndTest:Move( 7, 20 )
   wndTest:Say( 5, 2, "Pulsa una tecla..." )
   InKey( 0 )

   wndTest:Hide()

return

//----------------------------------------------------------------------------//
