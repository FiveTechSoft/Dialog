/************************************************************************
 Fichero..: D_MODEM.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgModem
 Fecha....: 05-23-92 01:38pm
 Versi¢n..: 1.00
 Notas....: Edit, estilo de Edici¢n...
 Autor....: Carlos Segura Sanz
************************************************************************/


#include "dialog.ch"

#define ID_nINIT      1
#define ID_nDIAL      2
#define ID_nANSW      3
#define ID_nHANG      4
#define ID_nRESET     5
#define ID_nESC       6
#define ID_nOK        7
#define ID_nCANCEL    8

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgModem():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgModem - Test", 79 ) color "gr+/b"

   alert( "Configuraci¢n", dlgTest:aExec() )
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgModem FROM Dialog

   VAR edtInit
   VAR edtDial
   VAR edtAnsw
   VAR edtHang
   VAR edtReset
   VAR edtEsc
   VAR pbtOk
   VAR pbtCancel
   VAR aResult                      

   METHOD New           = DmodNew
   METHOD PbtClick      = DmodPbtClick
   METHOD aExec         = aDmodExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DmodNew()

   ::Parent:New( 2, 15, 17, 60, "Configuraci¢n del Modem" )

   ::edtInit    = Edit():New( 3, 3, 25, ;
                              "AT &Q0 &Q3 M1 S7=60 S11=55 V1 S0=6", ;
                              ID_nINIT, ;
                              "&Inicio", ;
                              " Cadena de Inicializaci¢n " )

   ::edtDial    = Edit():New( 5, 3, 25, ;
                              "ATDT", ;
                              ID_nDIAL, ;
                              "&Marcar", ;
                              " Cadena de Marcaje " )

   ::edtAnsw    = Edit():New( 7, 3, 25, ;
                              "ATA", ;
                              ID_nANSW, ;
                              "&Contestar", ;
                              " Descolgar para contestar " )

   ::edtHang    = Edit():New( 9, 3, 25, ;
                              "ATH0", ;
                              ID_nHANG, ;
                              "&Colgar", ;
                              " Colgar el tel‚fono " )

   ::edtReset   = Edit():New( 11, 3, 25, ;
                              "ATZ", ;
                              ID_nRESET, ;
                              "&Resetear", ;
                              " Resetear el Modem " )

   ::edtEsc     = Edit():New( 13, 3, 25, ;
                              "+++", ;
                              ID_nESC, ;
                              "&Escape", ;
                              " Secuencia de Escape " )

   ::pbtOk      = PushButton():New( 5, 35, ;
                                    "   &Ok   ", ;
                                    ID_nOK, ;
                                    " Continuar " )

   ::pbtCancel  = PushButton():New( 9, 35, ;
                                    " &Cancel ", ;
                                    ID_nCANCEL, ;
                                    " Cancelar " )

   ::AddControl( ::edtInit   )
   ::AddControl( ::edtDial   )
   ::AddControl( ::edtAnsw   ) 
   ::AddControl( ::edtHang   ) 
   ::AddControl( ::edtReset  )
   ::AddControl( ::edtEsc    )
   ::AddControl( ::pbtOk     )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DmodPbtClick( oPbt )

   do case
      case oPbt:nId == ID_nOK
           aResult = { ::edtInit:cText,  ;
                       ::edtDial:cText,  ;
                       ::edtAnsw:cText,  ;
                       ::edtHang:cText,  ; 
                       ::edtReset:cText, ;  
                       ::edtEsc:cText    }
           ::lEndExec = .t.
      case oPbt:nId == ID_nCANCEL
           ::aResult = {}
           ::lEndExec = .t.
   endcase
            
return            
                  
//----------------------------------------------------------------------------//

METHOD function aDmodExec()

 ::Exec()

return ::aResult
