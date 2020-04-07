#include "dialog.ch"

#define ID_nDRIVES 1
#define ID_nSIZES  2
#define ID_nSYSTEM 3
#define ID_nMODE   4
#define ID_nVOLUME 5
#define ID_nSAVE   6
#define ID_nBEGIN  7
#define ID_nCANCEL 8

//----------------------------------------------------------------------------//

function Main()

   local dlgFormat := DlgFormat():New()

   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgFormat:Exec()
   dlgFormat:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgFormat FROM Dialog

   VAR lbxDrives, lbxSizes
   VAR rbmSystem, rbmMode
   VAR edtVolume
   VAR cbtSave
   VAR pbtBegin, pbtCancel

   METHOD New           = DfrNew
   METHOD CtrlGotFocus  = DfrCtrlGotFocus
   METHOD CtrlLostFocus = DfrCtrlLostFocus
   METHOD LbxSelect     = DfrLbxSelected
   METHOD PbtClick      = DfrPbtClick

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DfrNew()

   ::Parent:New( 5, 5, 18, 73, "Formateo de Discos" )

   ::lbxDrives = ListBox():New( 3, 3, 7, 10, "&Unidades", ID_nDRIVES,;
                 " Seleccione la unidad a formatear " )
   ::lbxSizes  = ListBox():New( 3, 13, 7, 20, "&Tama¤os", ID_nSIZES,;
                 " Seleccione el tama¤o deseado " )
   ::rbmSystem = RbMenu():New( 3, 24, "&Archivos Sistema", ID_nSYSTEM,;
                 " Que hacer con los ficheros de Sistema " )
   ::rbmMode   = RbMenu():New( 3, 48, "&Modo", ID_nMODE,;
                 " Seleccione el modo de formateo " )
   ::edtVolume = Edit():New( 9, 21, 12, "", ID_nVOLUME, "Eti&queta",;
                 " Nombre a ponerle al disco " )
   ::cbtSave   = CheckBtn():New( 9, 41, "Sa&lvar Info", ID_nSAVE,;
                 " Salvar la informaci¢n contenida en el disco " )
   ::pbtBegin  = PushButton():New( 11, 22, " C&omenzar ", ID_nBEGIN,;
                 " Comenzar a formatear el disco " )
   ::pbtCancel = PushButton():New( 11, 40, " &Cancelar ", ID_nCANCEL,;
                 " Terminar la operaci¢n " )

   ::lbxDrives:acItems = { " [-A-] ", " [-B-] " }
   ::lbxSizes:acItems  = { " 180K ", " 320K ", " 360K ", " 1.2M " }
   ::edtVolume:oLabel:Move( 0, -9 )
   ::edtVolume:nMaxLen = 20
   ::pbtBegin:lDefault = .t.

   ::rbmSystem:AddItem( "&No incluirlos " )
   ::rbmSystem:AddItem( "&Incluirlos " )
   ::rbmSystem:AddItem( "&Reservar Espacio " )

   ::rbmMode:AddItem( "R&ecuperable " )
   ::rbmMode:AddItem( "R &pido " )
   ::rbmMode:AddItem( "&Standard DOS " )

   ::AddControl( ::lbxDrives )
   ::AddControl( ::lbxSizes )
   ::AddControl( ::rbmSystem )
   ::AddControl( ::rbmMode )
   ::AddControl( ::edtVolume )
   ::AddControl( ::cbtSave )
   ::AddControl( ::pbtBegin )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DfrCtrlGotFocus( oControl )

   do case
      case oControl:nId == ID_nCANCEL
           ::pbtBegin:lDefault = .f.
           ::pbtBegin:Display()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DfrCtrlLostFocus( oControl )

   do case
      case oControl:nId == ID_nCANCEL
           ::pbtBegin:lDefault = .t.
           ::pbtBegin:Display()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DfrLbxSelect( oLbx )

   do case
      case oLbx:nId == ID_nDRIVES
           do case
              case oLbx:nOption == 1
                   ::lbxSizes:SetItems( ;
                   { " 180K ", " 320K ", " 360K ", " 1.2M " } )

              case oLbx:nOption == 2
                   ::lbxSizes:SetItems( { " 720K ", " 1.4M " } )
           endcase
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DfrPbtClick( oPushButton )

   if oPushButton:nId == ID_nCANCEL
      ::EndExec()
   endif

return

//----------------------------------------------------------------------------//
