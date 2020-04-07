#include "dialog.ch"

//----------------------------------------------------------------------------//

function Main()

   local lbxTest := ListBox():New( 6, 29, 16, 49, "&Seleccione", 0,;
                                   " Elija un valor " )

   lbxTest:acItems = { " Esto ",;
                       " Es   ",;
                       " una  ",;
                       " prueba ",;
                       " de ",;
                       " un ",;
                       " Objeto ",;
                       " ListBox. ",;
                       " Todos ",;
                       " Los ",;
                       " Objetos ",;
                       " de ",;
                       " la ",;
                       " librer¡a ",;
                       " Dialog ",;
                       " pueden ",;
                       " funcionar ",;
                       " c¢mo ",;
                       " Controles ",;
                       " de ",;
                       " una ",;
                       " Caja ",;
                       " de ",;
                       " Di logo ",;
                       " ¢ ",;
                       " c¢mo ",;
                       " elementos ",;
                       " independientes. ",;
                       " Aqu¡ ",;
                       " tienes ",;
                       " el ",;
                       " ejemplo " }

   SetColor( "W+/B" )
   CLS
   @ 23, 16 SAY "Dialog ver. 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   lbxTest:Exec()
   lbxTest:Hide()

return

//----------------------------------------------------------------------------//
