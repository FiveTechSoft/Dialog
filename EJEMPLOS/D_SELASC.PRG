/************************************************************************
 Fichero..: D_SELASC.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgSelChar
 Fecha....: 05-20-92 02:49am
 Versi¢n..: 1.00
 Notas....: Casi sin querer...
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nCHARS       1
#define ID_nOK          2
#define ID_nCANCEL      3

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgSelChar():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgSelChar - Test", 79 ) color "gr+/b"

   alert( "Selecciono : " + dlgTest:cExec() )
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgSelChar FROM Dialog

   VAR lbxChars
   VAR pbtOk
   VAR pbtCancel
   VAR cResult

   METHOD New        = DscNew
   METHOD PbtClick   = DscPbtClick   
   METHOD cExec      = cDscExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DscNew()

   local n

   ::Parent:New( 3, 15, 19, 45, "Car cter ASCII" )

   ::lbxChars   = ListBox():New( 3, 3, 11, 27, ;
                                 "Ca&r cteres", ;
                                 ID_nCHARS, ;
                                 " Elija el car cter " )

   ::pbtOk      = PushButton():New( 14, 2, ;
                                    "    &Ok   ", ;
                                    ID_nOK, ;
                                    " Seleccionar " )

   ::pbtCancel  = PushButton():New( 14, 16, ;
                                    " &Cancelar ", ;
                                    ID_nCANCEL, ;
                                    " Cancelar la selecci¢n " )
   
   for n = 1 to 255
       aadd( ::lbxChars:acItems, space( 1 ) + padr( n, 5 ) + ;
                                 chr( n ) + space( 3 ) )
   next

   ::AddControl( ::lbxChars  )
   ::AddControl( ::pbtOk     )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DscPbtClick( oPbt )

   do case
      case oPbt:nId == ID_nOK
           ::cResult = chr( ::lbxChars:nOption )
           ::lEndExec = .t. 
      case oPbt:nId == ID_nCANCEL
           ::cResult = ""
           ::lEndExec = .t. 
   endcase

return 

//----------------------------------------------------------------------------//

METHOD function cDscExec()

   ::Exec()

return ::cResult
            

