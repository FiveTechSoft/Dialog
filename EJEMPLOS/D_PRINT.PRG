/************************************************************************
 Fichero..: D_PRINTE.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgPrinter
 Fecha....: 05-23-92 02:10pm
 Versi¢n..: 1.00
 Notas....: ¨ Una Impresora o Un fichero ?, RBMenu dir .  
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nDISP         1
#define ID_nPORT         2
#define ID_nFILE         3
#define ID_nQLTY         4
#define ID_nOK           5
#define ID_nCANCEL       6

//----------------------------------------------------------------------------//

function Main()
 
 local dlgTest := DlgPrinter():New()
 local aParam

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgPrinter - Test", 79 ) color "gr+/b"

   aParam = dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgPrinter FROM Dialog
   
   VAR rbmDisp
   VAR rbmPort
   VAR rbmQlty
   VAR edtFile
   VAR pbtOk
   VAR pbtCancel
   VAR aResult

   METHOD New        = DPrnNew
   METHOD Init       = DPrnInit
   /*
   METHOD PbtClick   = DPrnPbtClick
   METHOD aExec      = aDPrnExec
   */
ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DPrnNew()

   ::Parent:New( 4, 10, 17, 55, "Impresi¢n" )
   
   ::rbmDisp = RBMenu():New( 3, 4,  ;
                             "&Dispositivo", ;
                             ID_nDISP, ;
                             " Selecione el dispositivo " )

   ::rbmPort = RbMenu():New( 3, 22, ;
                             "&Puerto", ;
                             ID_nPORT, ;
                             " Seleccione el puerto " )

   ::rbmQlty = RbMenu():New( 9, 4, ;
                             "C&alidad", ;
                             ID_nQLTY, ;
                             " Seleccione la calidad " )

   ::edtFile = Edit():New( 9, 22, 15, ;
                           "IMPRESO.PRN", ;
                           ID_nFILE, ;
                           "&Fichero", ;
                           " Nombre del fichero " )
    
   ::pbtOk     = PushButton():New( 11, 22, ;
                                   "   &Ok   ",;
                                   ID_nOK, ;
                                   " Continuar " )

   ::pbtCancel = PushButton():New( 11, 32, ;
                                   " &Cancel ", ;
                                   ID_nCANCEL, ;
                                   " Cancelar " )

   ::rbmDisp:AddItem( "Fichero" )
   ::rbmDisp:AddItem( "Impresora " )

   ::rbmPort:AddItem( "PRN" )
   ::rbmPort:AddItem( "LPT 1 " )
   ::rbmPort:AddItem( "LPT 2 " )

   ::rbmQlty:AddItem( "Draft" )
   ::rbmQlty:AddItem( "Norlmal   " )
   ::rbmQlty:AddItem( "Calidad   " )

   ::AddControl( ::rbmDisp )
   ::AddControl( ::rbmPort )
   ::AddControl( ::rbmQlty )
   ::AddControl( ::edtFile )
   ::AddControl( ::pbtOk   )
   ::AddControl( ::pbtCancel )

return Self   

//----------------------------------------------------------------------------//

METHOD function DPrnInit()
 local n
 
 ::Box( 2,  3,  5, 19 )
 ::Box( 2, 21,  6, 33 )
 ::Box( 8,  3, 12, 19 )
 ::Box( 8, 21, 10, 41 )
 AEval( ::aControls, { | oControl | oControl:Display() } )

return 

/*
METHOD function DPrnPbtClick( Pbt )

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
*/

