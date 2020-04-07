#include "dialog.ch"

#define ID_nFRENTE     100
#define ID_nFONDO      200
#define ID_nOK         300
#define ID_nCANCEL     400
#define ID_nINTENSIDAD 500
#define ID_nPARPADEO   600
#define ID_nCOLORES    700

//----------------------------------------------------------------------------//

function Main()

   local dclTest := DlgColor():New()


   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dclTest:Exec()
   dclTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgColor FROM Dialog

   VAR rbmFrente, rbmFondo, rbmColores
   VAR pbtOk, pbtCancel
   VAR cbtIntensidad, cbtParpadeo
   VAR cClrOld, cClrNew

   METHOD New          = DclNew
   METHOD Init         = DclInit
   METHOD RbmChanged   = DclRbmChanged
   METHOD CbtChanged   = DclCbtChanged
   METHOD CtrlGotFocus = DclCtrlGotFocus
   METHOD PbtClick     = DclPbtClick

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DclNew()

   ::Parent:New( 3, 14, 18, 63, "Seleccione un Color" )

   ::rbmFrente  = RbMenu():New( 3, 2, "&Primer plano", ID_nFRENTE,;
                                " Color para el primer plano " )
   ::rbmFondo   = RbMenu():New( 3, 17, "&Fondo", ID_nFONDO,;
                                " Color para el Fondo " )
   ::rbmColores = RbMenu():New( 11, 32, "Co&lores Fondo", ID_nCOLORES,;
                                " N£mero de colores a usar para el fondo " )
   ::pbtOk     = PushButton():New( 2, 34, "    &Ok    ", ID_nOK,;
                                   " De acuerdo " )
   ::pbtCancel = PushButton():New( 4, 34, " &Cancelar ", ID_nCANCEL,;
                                   " Abandonar la selecci¢n " )
   ::cbtIntensidad = CheckBtn():New( 7, 31, "&Intensidad", ID_nINTENSIDAD,;
                                     " Selecci¢n de Intensidad " )
   ::cbtParpadeo   = CheckBtn():New( 8, 31, "P&arpadeo", ID_nPARPADEO,;
                                     " Selecci¢n de Parpadeo " )
   ::cClrOld        = SetColor()
   ::cClrNew        = ""
   SetBlink( .f. )
   ::pbtOk:lDefault = .t.

   ::rbmFrente:AddItem( "&Negro" )
   ::rbmFrente:AddItem( "A&zul" )
   ::rbmFrente:AddItem( "&Verde" )
   ::rbmFrente:AddItem( "&Celeste " )
   ::rbmFrente:AddItem( "&Rojo" )
   ::rbmFrente:AddItem( "&Magenta" )
   ::rbmFrente:AddItem( "M&arr¢n" )
   ::rbmFrente:AddItem( "&Blanco" )

   ::rbmFondo:AddItem( "&Negro" )
   ::rbmFondo:AddItem( "A&zul" )
   ::rbmFondo:AddItem( "&Verde" )
   ::rbmFondo:AddItem( "&Celeste " )
   ::rbmFondo:AddItem( "&Rojo" )
   ::rbmFondo:AddItem( "&Magenta" )
   ::rbmFondo:AddItem( "M&arr¢n" )
   ::rbmFondo:AddItem( "&Blanco" )

   ::rbmColores:AddItem( " &8 Colores " )
   ::rbmColores:AddItem( "&16 Colores " )

   ::rbmFrente:aItems[ 1 ]:cClrNormal = "W/N"
   ::rbmFrente:aItems[ 2 ]:cClrNormal = "W/B"
   ::rbmFrente:aItems[ 3 ]:cClrNormal = "N/G"
   ::rbmFrente:aItems[ 4 ]:cClrNormal = "N/BG"
   ::rbmFrente:aItems[ 5 ]:cClrNormal = "W/R"
   ::rbmFrente:aItems[ 6 ]:cClrNormal = "W/RB"
   ::rbmFrente:aItems[ 7 ]:cClrNormal = "W/GR"
   ::rbmFrente:aItems[ 8 ]:cClrNormal = "N/W"
   ::rbmFrente:aItems[ 1 ]:cClrFocus  = "W+/N"
   ::rbmFrente:aItems[ 2 ]:cClrFocus  = "W+/B"
   ::rbmFrente:aItems[ 3 ]:cClrFocus  = "W+/G"
   ::rbmFrente:aItems[ 4 ]:cClrFocus  = "W+/BG"
   ::rbmFrente:aItems[ 5 ]:cClrFocus  = "W+/R"
   ::rbmFrente:aItems[ 6 ]:cClrFocus  = "W+/RB"
   ::rbmFrente:aItems[ 7 ]:cClrFocus  = "W+/GR"
   ::rbmFrente:aItems[ 8 ]:cClrFocus  = "W+/W"

   ::rbmFondo:aItems[ 1 ]:cClrNormal = "W/N"
   ::rbmFondo:aItems[ 2 ]:cClrNormal = "W/B"
   ::rbmFondo:aItems[ 3 ]:cClrNormal = "N/G"
   ::rbmFondo:aItems[ 4 ]:cClrNormal = "N/BG"
   ::rbmFondo:aItems[ 5 ]:cClrNormal = "W/R"
   ::rbmFondo:aItems[ 6 ]:cClrNormal = "W/RB"
   ::rbmFondo:aItems[ 7 ]:cClrNormal = "W/GR"
   ::rbmFondo:aItems[ 8 ]:cClrNormal = "N/W"
   ::rbmFondo:aItems[ 1 ]:cClrFocus  = "W+/N"
   ::rbmFondo:aItems[ 2 ]:cClrFocus  = "W+/B"
   ::rbmFondo:aItems[ 3 ]:cClrFocus  = "W+/G"
   ::rbmFondo:aItems[ 4 ]:cClrFocus  = "W+/BG"
   ::rbmFondo:aItems[ 5 ]:cClrFocus  = "W+/R"
   ::rbmFondo:aItems[ 6 ]:cClrFocus  = "W+/RB"
   ::rbmFondo:aItems[ 7 ]:cClrFocus  = "W+/GR"
   ::rbmFondo:aItems[ 8 ]:cClrFocus  = "W+/W"

   ::AddControl( ::rbmFrente )
   ::AddControl( ::rbmFondo )
   ::AddControl( ::pbtOk )
   ::AddControl( ::pbtCancel )
   ::AddControl( ::cbtIntensidad )
   ::AddControl( ::cbtParpadeo )
   ::AddControl( ::rbmColores )

return Self

//----------------------------------------------------------------------------//

METHOD function DclInit()

   ::cClrNew = ;
      SubStr( ::rbmFrente:aItems[ ::rbmFrente:nOption ]:cClrNormal,;
      At( "/", ::rbmFrente:aItems[ ::rbmFrente:nOption ]:cClrNormal ) + 1 ) + ;
      If( ::cbtIntensidad:lChecked, "+", "" ) + ;
      If( ::cbtParpadeo:lChecked, "*", "" ) + "/" + ;
      SubStr( ::rbmFondo:aItems[ ::rbmFondo:nOption ]:cClrNormal,;
      At( "/", ::rbmFondo:aItems[ ::rbmFondo:nOption ]:cClrNormal ) + 1 )

   ::Say( 12,  2, "ÛßßßßßßßßßßßßßßßßßßßßßßßßßßÛ", ::cClrNew )
   ::Say( 13,  2, "Û     Prueba de Color      Û", ::cClrNew )
   ::Say( 14,  2, "ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛ", ::cClrNew )
   ::Say( 14, 32, PadC( "=> " + ::cClrNew, 15 ) )

return

//----------------------------------------------------------------------------//

METHOD function DclRbmChanged( oRbMenu )

   if oRbMenu:nId != ID_nCOLORES
      ::Init()
   else
      SetBlink( oRbMenu:nOption == 1 )
   endif

return

//----------------------------------------------------------------------------//

METHOD function DclCbtChanged( oCheckBtn )

   ::Init()

return

//----------------------------------------------------------------------------//

METHOD function DclCtrlGotFocus( oControl )

   ::pbtOk:lDefault = ( oControl:nId != ID_nCANCEL )
   ::pbtOk:Display()

return

//----------------------------------------------------------------------------//

METHOD function DclPbtClick( oPushButton )

   if oPushButton:nId == ID_nCANCEL
      ::cClrNew = ""
   endif
   ::EndExec()

return

//----------------------------------------------------------------------------//
