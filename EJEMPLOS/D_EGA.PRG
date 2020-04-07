// Demo librer¡a Dialog para Clipper 5

#include "dialog.ch"

#define ID_nREGISTROS  100
#define ID_nCOLORES    200
#define ID_nESTABLECER 300
#define ID_nRESTODOS   400
#define ID_nRESESTE    500
#define ID_nTERMINAR   600

//----------------------------------------------------------------------------//

function Main()

   local degTest := DlgEga():New()

   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   degTest:Exec()
   degTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgEga FROM Dialog

   VAR rbmRegistros
   VAR cbmColores
   VAR anStandard, anNew
   VAR pbtEstablecer, pbtResTodos, pbtResEste, pbtTerminar

   METHOD New        = DegNew            // Constructor obligatorio !
   METHOD Init       = DegInit           // Redefinici¢n de m‚todo de Dialog
   METHOD RbmChanged = DegRbmChanged     // Redefinici¢n de m‚todo de Dialog
   METHOD CbmChanged = DegCbmChanged     // Redefinici¢n de m‚todo de Dialog
   METHOD PbtClick   = DegPbtClick       // Redefinici¢n de m‚todo de Dialog
   METHOD SetColors  = DegSetColors      // M‚todo nuevo

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DegNew()

   ::Parent:New( 1, 10, 20, 69, "Colores EGA" )

   ::rbmRegistros  = RbMenu():New( 2, 3, "&Registros", ID_nREGISTROS,;
                                   " Registros de la tarjeta EGA " )
   ::cbmColores    = CbMenu():New( 2, 31, "&Colores", ID_nCOLORES,;
                                   " Colores a utilizar " )
   ::anStandard    = { 0, 1, 2, 3, 4, 5, 20, 7, 56, 57, 58, 59, 60, 61, 62, 63 }
   ::anNew         = { 0, 1, 2, 3, 4, 5, 20, 7, 56, 57, 58, 59, 60, 61, 62, 63 }
   ::pbtEstablecer = PushButton():New( 11, 36,;
                                       " Esta&blecer Este ",;
                                       ID_nESTABLECER,;
                                   " Establecer los colores de este Registro " )
   ::pbtResTodos   = PushButton():New( 13, 36,;
                                       " Resetear &Todos  ",;
                                       ID_nRESTODOS,;
                 " Establecer los colores por defecto de todos los Registros " )
   ::pbtResEste    = PushButton():New( 15, 36,;
                                       " Resetear &Este   ",;
                                       ID_nRESESTE,;
                     " Establecer los colores por defecto de este Registro " )
   ::pbtTerminar   = PushButton():New( 17, 36,;
                                       " Ter&minar        ",;
                                       ID_nTERMINAR,;
                                       " Terminar la ejecuci¢n " )

   ::rbmRegistros:AddItem( " 0 - &Negro" )
   ::rbmRegistros:AddItem( " 1 - &Azul" )
   ::rbmRegistros:AddItem( " 2 - &Verde" )
   ::rbmRegistros:AddItem( " 3 - &Celeste" )
   ::rbmRegistros:AddItem( " 4 - Ro&jo" )
   ::rbmRegistros:AddItem( " 5 - V&ioleta" )
   ::rbmRegistros:AddItem( " 6 - &Marr¢n" )
   ::rbmRegistros:AddItem( " 7 - &Blanco" )
   ::rbmRegistros:AddItem( " 8 - &Gris oscuro" )
   ::rbmRegistros:AddItem( " 9 - A&zul claro" )
   ::rbmRegistros:AddItem( "10 - V&erde claro" )
   ::rbmRegistros:AddItem( "11 - R&ojo claro" )
   ::rbmRegistros:AddItem( "12 - Ce&leste claro" )
   ::rbmRegistros:AddItem( "13 - Viole&ta claro" )
   ::rbmRegistros:AddItem( "14 - Ama&rillo" )
   ::rbmRegistros:AddItem( "15 - Blanco inten&so " )

   ::cbmColores:AddItem( "0 - &Azul" )
   ::cbmColores:AddItem( "1 - &Verde" )
   ::cbmColores:AddItem( "2 - &Rojo" )
   ::cbmColores:AddItem( "3 - A&zul secundario" )
   ::cbmColores:AddItem( "4 - V&erde secundario " )
   ::cbmColores:AddItem( "5 - R&ojo secundario" )
   ::cbmColores:AddItem( "6 - Re&servado" )
   ::cbmColores:AddItem( "7 - Reserva&do" )

   ::AddControl( ::rbmRegistros )
   ::AddControl( ::cbmColores )
   ::AddControl( ::pbtEstablecer )
   ::AddControl( ::pbtResTodos )
   ::AddControl( ::pbtResEste )
   ::AddControl( ::pbtTerminar )

return Self

//----------------------------------------------------------------------------//

METHOD function DegInit()

   ::SetColors()

return

//----------------------------------------------------------------------------//

METHOD function DegRbmChanged( oRbMenu )

   ::SetColors()

return

//----------------------------------------------------------------------------//

METHOD function DegCbmChanged( oCbMenu )

   local nNewValue := If( ::cbmColores:aItems[ 1 ]:lChecked,   1, 0 ) + ;
                      If( ::cbmColores:aItems[ 2 ]:lChecked,   2, 0 ) + ;
                      If( ::cbmColores:aItems[ 3 ]:lChecked,   4, 0 ) + ;
                      If( ::cbmColores:aItems[ 4 ]:lChecked,   8, 0 ) + ;
                      If( ::cbmColores:aItems[ 5 ]:lChecked,  16, 0 ) + ;
                      If( ::cbmColores:aItems[ 6 ]:lChecked,  32, 0 ) + ;
                      If( ::cbmColores:aItems[ 7 ]:lChecked,  64, 0 ) + ;
                      If( ::cbmColores:aItems[ 8 ]:lChecked, 128, 0 )

   EgaColor( ::rbmRegistros:nOption - 1, nNewValue )

return

//----------------------------------------------------------------------------//

METHOD function DegPbtClick( oPushButton )

   local n

   do case
      case oPushButton:nId == ID_nESTABLECER
           ::anNew[ ::rbmRegistros:nOption ] = ;
           If( ::cbmColores:aItems[ 1 ]:lChecked,   1, 0 ) + ;
           If( ::cbmColores:aItems[ 2 ]:lChecked,   2, 0 ) + ;
           If( ::cbmColores:aItems[ 3 ]:lChecked,   4, 0 ) + ;
           If( ::cbmColores:aItems[ 4 ]:lChecked,   8, 0 ) + ;
           If( ::cbmColores:aItems[ 5 ]:lChecked,  16, 0 ) + ;
           If( ::cbmColores:aItems[ 6 ]:lChecked,  32, 0 ) + ;
           If( ::cbmColores:aItems[ 7 ]:lChecked,  64, 0 ) + ;
           If( ::cbmColores:aItems[ 8 ]:lChecked, 128, 0 )

      case oPushButton:nId == ID_nRESTODOS
           for n = 1 to Len( ::anStandard )
               EgaColor( n - 1, ::anStandard[ n ] )
           next
           ACopy( ::anStandard, ::anNew )

      case oPushButton:nId == ID_nRESESTE
           EgaColor( ::rbmRegistros:nOption - 1,;
                     ::anStandard[ ::rbmRegistros:nOption ] )
           ::anNew[ ::rbmRegistros:nOption ] = ;
           ::anStandard[ ::rbmRegistros:nOption ]

      case oPushButton:nId == ID_nTERMINAR
           for n = 1 to Len( ::anNew )
               EgaColor( n - 1, ::anNew[ n ] )
           next
           ::EndExec()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DegSetColors()

   local n

   for n = 1 to 8
       ::cbmColores:SetValue( n,;
       lBitOn( ::anNew[ ::rbmRegistros:nOption ], n - 1 ) )
   next

return

//----------------------------------------------------------------------------//
