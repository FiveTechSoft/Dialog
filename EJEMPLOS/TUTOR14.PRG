#include "dialog.ch"

#define ID_nDIA    100
#define ID_nACCION 200
#define ID_nOK     300

//----------------------------------------------------------------------------//

function Main()

   local dtsTest := DlgTest():New()

   AltD( 0 )                              // para poder usar Alt-D
   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dtsTest:Exec()
   dtsTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR rbmDia
   VAR cbmAccion
   VAR pbtOk
   VAR aAcciones

   METHOD New        = DtsNew         // Constructor obligatorio !!!
   METHOD Init       = DtsInit        // Redefinici¢n de m‚todo de Dialog
   METHOD PbtClick   = DtsPbtClick    // Redefinici¢n de m‚todo de Dialog
   METHOD RbmChanged = DtsRbmChanged  // Redefinici¢n de m‚todo de Dialog
   METHOD CbmChanged = DtsCbmChanged  // Redefinici¢n de m‚todo de Dialog
   METHOD Update     = DtsUpdate      // M‚todo nuevo

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 5, 5, 18, 75, " Planning " )

   ::rbmDia    = RbMenu():New( 3, 4, "&D¡a", ID_nDIA,;
                               " Seleccione un d¡a laboral " )
   ::cbmAccion = CbMenu():New( 8, 4, "&Acci¢n", ID_nACCION,;
                               " Actividad a desarrollar " )
   ::pbtOk     = PushButton():New( 11, 31, "   &Ok   ", ID_nOK, " Terminar " )
   ::aAcciones = { { .t., .t., .f., .f. },;
                   { .f., .t., .t., .f. },;
                   { .t., .t., .t., .f. },;
                   { .t., .f., .f., .t. },;
                   { .f., .f., .f., .t. } }

   ::rbmDia:lHorizontal = .t.
   ::rbmDia:AddItem( "&Lunes " )
   ::rbmDia:AddItem( "&Martes " )
   ::rbmDia:AddItem( "M&i‚rcoles " )
   ::rbmDia:AddItem( "&Jueves " )
   ::rbmDia:AddItem( "&Viernes " )

   ::cbmAccion:lHorizontal = .t.
   ::cbmAccion:AddItem( "&Telefonear " )
   ::cbmAccion:AddItem( "&Visitar " )
   ::cbmAccion:AddItem( "&Enviar Carta " )
   ::cbmAccion:AddItem( "Ce&na       " )

   ::pbtOk:lDefault = .t.

   ::AddControl( ::rbmDia )
   ::AddControl( ::cbmAccion )
   ::AddControl( ::pbtOk )

return Self

//----------------------------------------------------------------------------//

METHOD function DtsInit()

   ::Box( 2, 2, 4, 68 )
   ::Box( 7, 2, 9, 68 )
   ::rbmDia:Display()
   ::cbmAccion:Display()
   ::Update()

return

//----------------------------------------------------------------------------//

METHOD function DtsPbtClick( oPushButton )

   ::EndExec()

return

//----------------------------------------------------------------------------//

METHOD function DtsRbmChanged( oRbMenu )

   ::Update()

return

//----------------------------------------------------------------------------//

METHOD function DtsCbmChanged( oCbMenu )

   ::aAcciones[ ::rbmDia:nOption ][ ::cbmAccion:nOption ] = ;
   ::cbmAccion:aItems[ ::cbmAccion:nOption ]:lChecked

return

//----------------------------------------------------------------------------//

METHOD function DtsUpdate()

   local n

   for n = 1 to 4
       ::cbmAccion:SetValue( n, ::aAcciones[ ::rbmDia:nOption ][ n ] )
   next

return

//----------------------------------------------------------------------------//
