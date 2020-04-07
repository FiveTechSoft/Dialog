/************************************************************************
 Fichero..: D_OPNCOM.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgOpnCom
 Fecha....: 05-19-92 02:46pm
 Versi¢n..: 1.00
 Notas....: CheckButtonMenu, lo hace todo el solito.
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nPORT     1
#define ID_nBAUD     2
#define ID_nSTOP     3
#define ID_nPARITY   4
#define ID_nDATA     5
#define ID_nOK       6
#define ID_nCANCEL   7

//----------------------------------------------------------------------------//

function Main()
 
 local docTest := DlgOpnCom():New()
 local aParam

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgOpnCom - Test", 79 ) color "gr+/b"

   aParam = docTest:aExec()
   alert( "Par metros", { aParam[1],;
                          str( aParam[2] ), ;
                          str( aParam[3] ), ;
                          str( aParam[4] ), ;
                          str( aParam[5] )  } )
   docTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgOpnCom FROM Dialog
   
   VAR cbxPort
   VAR rbmBaud
   VAR rbmStop
   VAR rbmData
   VAR rbmPar
   VAR pbtOk
   VAR pbtCancel
   VAR aResult

   METHOD New        = DocNew
   METHOD PbtClick   = DocPbtClick
   METHOD aExec      = aDocExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DocNew()

   ::Parent:New( 4, 10, 17, 49, "Configuraci¢n del Puerto" )
   
   ::cbxPort = ComboBox():New( 2, 2, 6, ;
                               "", ;
                               ID_nPORT, ;
                               "&Puerto", ;
                               " Selecione el Puerto " )

   ::rbmBaud = RbMenu():New( 2, 12, ;
                             "&Velocidad", ;
                             ID_nBAUD, ;
                             " Seleccione la velocidad del puerto " )

   ::rbmStop = RbMenu():New( 2, 24, ;
                             "Bits &Stop", ;
                             ID_nSTOP, ;
                             " Seleccione los Bits de Stop " )

   ::rbmData = RbMenu():New( 6, 24, ;
                             "Bits de &Datos", ;
                             ID_nDATA, ;
                             " Seleccione los Bits de Datos " )

   ::rbmPar  = RbMenu():New( 10, 24, ;
                             "P&aridad", ;
                             ID_nPARITY, ;
                             " Seleccione la Paridad " )
    
   ::pbtOk     = PushButton():New( 5, 2, ;
                                   "   &Ok   ",;
                                   ID_nOK, ;
                                   " Continuar " )

   ::pbtCancel = PushButton():New( 9, 2, ;
                                   " &Cancel ", ;
                                   ID_nCANCEL, ;
                                   " Cancelar " )

   ::cbxPort:oListBox:acItems = { "COM1", "COM2", "COM3", "COM4" }

   ::rbmBaud:AddItem( "75   " )
   ::rbmBaud:AddItem( "300  " )
   ::rbmBaud:AddItem( "1200 " )
   ::rbmBaud:AddItem( "2400 " )
   ::rbmBaud:AddItem( "4800 " )
   ::rbmBaud:AddItem( "9600 " )
   ::rbmBaud:AddItem( "14400" )
   ::rbmBaud:AddItem( "19200" )
   ::rbmBaud:AddItem( "38400 " )

   ::rbmStop:AddItem( "1 Bit " )
   ::rbmStop:AddItem( "2 Bits  " )

   ::rbmData:AddItem( "7 Bits" )
   ::rbmData:AddItem( "8 Bits  " )

   ::rbmPar:AddItem( "Par"     )
   ::rbmPar:AddItem( "Impar"   )
   ::rbmPar:AddItem( "Ninguna " )

   ::AddControl( ::cbxPort )
   ::AddControl( ::rbmBaud )
   ::AddControl( ::rbmStop )
   ::AddControl( ::rbmData )
   ::AddControl( ::rbmPar  )
   ::AddControl( ::pbtOk   )
   ::AddControl( ::pbtCancel )

return Self   

//----------------------------------------------------------------------------//

METHOD function DocPbtClick( Pbt )

   do case
      case Pbt:nId == ID_nOK
           ::aResult = { ::cbxPort:cText, ;
                         ::rbmBaud:nOption, ;
                         ::rbmStop:nOption, ;
                         ::rbmData:nOption, ;
                         ::rbmPar:nOption   }
           ::lEndExec = .t.
      case Pbt:nId == ID_nCANCEL
           ::aResult = {}
           ::lEndExec = .t. 
   endcase

return 

//----------------------------------------------------------------------------//

METHOD function aDocExec()

   ::Exec()

return ::aResult 
