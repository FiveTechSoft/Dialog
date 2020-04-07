/************************************************************************
 Fichero..: D_SELCOL.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgSelClr
 Fecha....: 05-18-92 05:08am
 Versi¢n..: 1.00
 Notas....: Un m‚todo Init para colorear. 
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nFORE        1
#define ID_nBACK        2
#define ID_nOK          3
#define ID_nCANCEL      4

//----------------------------------------------------------------------------//

function Main()
 
 local dscTest := DlgSelClr():New()

   setcolor( "w+/b" )
   cls
   @ 23, 10 say " DlgSelClr - Test " color "GR+/B"

   alert( dscTest:cExec() )
   dscTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgSelClr FROM Dialog
   
   VAR lbxFore
   VAR lbxBack
   VAR pbtOk
   VAR pbtCancel
   VAR cClrResult
   VAR cClrFore
   VAR cClrBack

   METHOD New        = DscNew
   METHOD Init       = DscInit
   METHOD LbxSelect  = DscLbxSelect
   METHOD PbtClick   = DscPbtClick
   METHOD cExec      = cDscExec

ENDCLASS
  
//----------------------------------------------------------------------------//

METHOD function DscNew()

   ::Parent:New( 4, 15, 19, 65, "Selecci¢n de Colores..." )
   
   ::lbxFore   = ListBox():New( 2,  3, 10, 16, ;
                               "&Car cter", ;
                               ID_nFORE, ;
                               " Seleccione el color del car cter " )

   ::lbxBack   = ListBox():New( 2, 20, 10, 33, ;
                                "&Fondo", ;
                                ID_nBACK, ;
                                " Seleccione el color del fondo " )
   
   ::pbtOk     = PushButton():New( 2, 37, ;
                                   "    &Ok    ",;
                                   ID_nOK, ;
                                   " Continuar " )

   ::pbtCancel = PushButton():New( 5, 37, ;
                                   "  &Cancel  ", ;
                                   ID_nCANCEL, ;
                                   " Cancelar " )

   ::lbxFore:acItems = { "N", "B", "G", "BG", "R", "RB", "GR", "W", ;
                         "N+", "B+", "G+", "BG+", "R+", "RB+", "GR+", "W+", ;
                         "N*", "B*", "G*", "BG*", "R*", "RB*", "GR*", "W*" }
   ::lbxBack:acItems = ::lbxFore:acItems

   ::cClrFore   = "n"
   ::cClrBack   = "n"
   
   ::AddControl( ::lbxFore )
   ::AddControl( ::lbxBack )
   ::AddControl( ::pbtOk   )
   ::AddControl( ::pbtCancel )   

return Self

//----------------------------------------------------------------------------//

METHOD function DscInit()

   ::cClrResult = ::cClrFore + "/" + ::cClrBack

   ::Say( 12, 2, space( 35 ),                   ::cClrResult )
   ::Say( 13, 2, padc( 'PRUEBA DE Color', 35 ), ::cClrResult )
   ::Say( 14, 2, space( 35 ),                   ::cClrResult )
   
return 

//----------------------------------------------------------------------------//

METHOD function DscLbxSelect( oListBox )

   local cItem := oListBox:acItems[ oListBox:nOption ]

   do case
      case oListBox:nId == ID_nFORE
           ::cClrFore = cItem
           ::Init()
      case oListBox:nId == ID_nBACK
           ::cClrBack = cItem
           ::Init()
  endcase

return

//----------------------------------------------------------------------------//

METHOD function DscPbtClick( Pbt )

   do case
      case Pbt:nId == ID_nOK
           ::lEndExec = .t.
      case Pbt:nId == ID_nCANCEL
           ::cClrResult = ""
           ::lEndExec = .t. 
   endcase

return

//----------------------------------------------------------------------------//

METHOD function cDscExec()

   ::Exec()

return ::cClrResult
