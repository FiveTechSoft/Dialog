/************************************************************************
 Fichero..: D_MKDBF.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgMakDbf
 Fecha....: 05-20-92 08:28pm
 Versi¢n..: 1.00
 Notas....: ¨Estructuras con oops? ­Dialog! 
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

/*
 * Identificadores de los controles
 */
#define ID_nNAME           1
#define ID_nTYPE           2
#define ID_nLEN            3
#define ID_nDEC            4
#define ID_nADD            5
#define ID_nEDIT           6
#define ID_nDEL            7
#define ID_nFIELDS         8
#define ID_nOK             10
#define ID_nCANCEL         11

/*
 * Errores posibles
 */
#define ERR_nEXIST         1
#define ERR_nEMPTY         2
#define ERR_nBADTYPE       3
#define ERR_nNOTVALID      4
#define ERR_nCHARTOOLONG   5
#define ERR_nNUMTOOLONG    6
#define ERR_nDECTOOSMALL   7
#define ERR_nDECTOOLONG    8

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgMakDbf():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgMakDbf - Test", 79 ) color "gr+/b"

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgMakDbf FROM Dialog

   VAR cbxType                       /* tipo del campo   */                      
   VAR edtName                       /* nombre           */
   VAR edtLen                        /* longitud         */
   VAR edtDec                        /* decimales        */
   VAR pbtAdd                        
   VAR pbtDel                        
   VAR pbtEdit                       
   VAR pbtOk                         
   VAR pbtCancel                     
   VAR lbxFields                     /* campos definidos   */
   VAR aaResult                      

   METHOD New           = DmdNew
   METHOD PbtClick      = DmdPbtClick
   METHOD CtrlGotFocus  = DmdCtrlGotFocus
   METHOD CtrlLostFocus = DmdCtrlLostFocus 
   METHOD Error         = DmdError
   METHOD lChkData      = lDmdChkData
   METHOD aaExec        = aaDmdExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DmdNew()

   ::Parent:New( 2, 15, 17, 65, "Estructura del DBF" )

   ::edtName    = Edit():New( 3, 3, 10, ;
                              "", ;
                              ID_nNAME, ;
                              "&Nombre", ;
                              " Nombre del campo " )

   ::cbxType    = ComboBox():New( 3, 16, 1, ;
                                  "C", ;
                                  ID_nTYPE, ;
                                  "&Tipo", ;
                                  " Seleccione el tipo adecuado " )

   ::edtLen      = Edit():New( 3, 21, 3, ;
                              " 10", ;
                              ID_nLEN, ;
                              "&Lon", ;
                              " Longitud del campo " )

   ::edtDec      = Edit():New( 3, 29, 2, ;
                              " 0", ;
                              ID_nDEC, ;
                              "&Dec", ;
                              " N£mero de decimales " )

   ::lbxFields  = ListBox():New( 6, 3, 11, 35, ;
                                 "Ca&mpos", ;
                                 ID_nFIELDS, ;
                                 " Elija un campo " )

   ::pbtAdd     = PushButton():New(  3, 39, ;
                                   " &A¤adir ", ;
                                   ID_nADD, ;
                                   " A¤adir este campo " )

   ::pbtEdit    = PushButton():New(  6, 39, ;
                                     " &Editar ", ;
                                     ID_nEDIT, ;
                                     " Editar este campo " )

   ::pbtDel     = PushButton():New(  8, 39, ;
                                     " &Borrar ", ;
                                     ID_nDEL, ;
                                     " Borrar este campo " )

   ::pbtOk      = PushButton():New( 13, 5, ;
                                    "     C&rear     ", ;
                                    ID_nOK, ;
                                    " Crear el fichero DBF " )

   ::pbtCancel  = PushButton():New( 13, 28, ;
                                    "    &Cancelar    ", ;
                                    ID_nCANCEL, ;
                                    " Cancelar toda la operaci¢n " )

   ::pbtEdit:lActive = .f.
   ::pbtDel:lActive  = .f.

   ::cbxType:oListBox:acItems = { "C", "N", "L", "D", "M" }

   ::AddControl( ::edtName   )
   ::AddControl( ::cbxType   )
   ::AddControl( ::edtLen    ) 
   ::AddControl( ::edtDec    ) 
   ::AddControl( ::pbtAdd    )
   ::AddControl( ::lbxFields )
   ::AddControl( ::pbtEdit   )
   ::AddControl( ::pbtDel    )
   ::AddControl( ::pbtOk     )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DmdCtrlLostFocus( oCtrl )
   local n

   do case
      case oCtrl:nId == ID_nTYPE
       
           /* valores por defecto seg£n el tipo de campo */

           if at( oCtrl:cText, "DdMmLl" ) > 0
              do case
                 case oCtrl:cText == "D"
                     ::edtLen:SetText( "8" )
                     ::edtDec:SetText( "0" )
                case oCtrl:cText == "M"
                     ::edtLen:SetText( "10" )
                     ::edtDec:SetText( "0" ) 
                case oCtrl:cText == "L"
                     ::edtLen:SetText( "1" )
                     ::edtDec:SetText( "0" ) 
             endcase                                     
             ::edtLen:lActive = .f.
             ::edtDec:lActive = .f.
          elseif at( oCtrl:cText, "Cc" ) > 0
             ::edtDec:lActive = .f.
          else
             ::edtLen:lActive = .t.
             ::edtDec:lActive = .t.
          endif
   endcase       

return

//----------------------------------------------------------------------------//

METHOD function DmdCtrlGotFocus( oCtrl )
   
   /* comprobamos si hay campos ya editados para poder editar y borrar */

   do case
      case oCtrl:nId == ID_nFIELDS
           if len( oCtrl:acItems ) >= 1
              ::pbtEdit:lActive = .t.
              ::pbtDel:lActive  = .t.
           else
              ::pbtEdit:lActive = .f.
              ::pbtDel:lActive  = .f.
           endif   
           ::pbtEdit:Display()
           ::pbtDel:Display()
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DmdPbtClick( oPbt )
   local c

   do case
      case oPbt:nId == ID_nADD
       
           /* chequear los datos */

           if ::lChkData()
              ::lbxFields:AddItem( padr( upper( ::edtName:cText ), 10 ) + ;
                                   space(4) + ;
                                   ::cbxType:cText +;
                                   space(4) + ;
                                   padl( ::edtLen:cText, 3 ) +;
                                   space(5) + ;
                                   padl( ::edtDec:cText, 2 ) )

               ::lbxFields:Display()  

               /* restaurar */

               ::edtName:SetText(    "" )
               ::cbxType:SetText(   "C" )
               ::edtLen:SetText(  " 10" )
               ::edtDec:SetText(   " 0" ) 
               ::edtLen:lActive = .t.
               ::edtDec:lActive = .t.
           endif

           /* otro */
          
           ::ChangeFocus( ::edtName )

      case oPbt:nId == ID_nDEL
           ::lbxFields:Delete( ::lbxFields:nOption )
           ::lbxFields:Display()

      case oPbt:nId == ID_nEDIT

           c = ::lbxFields:acItems[ ::lbxFields:nOption ]
           ::edtName:SetText( substr( c,  1, 10 ) )
           ::cbxType:SetText( substr( c, 15,  1 ) )
           ::edtLen:SetText(  substr( c, 19,  3 ) )
           ::edtDec:SetText(  substr( c, 27,  2 ) )
           ::lbxFields:Delete( ::lbxFields:nOption )
           ::lbxFields:Display()
           ::ChangeFocus( ::edtName )

      case oPbt:nId == ID_nOK
           ::aaResult = {}
           for n = 1 to len( ::lbxFields:acItems )
               c = ::lbxFields:acItems[ n ]
               aadd( ::aaResult, {  substr( c,  1, 10 ), ;
                                    substr( c, 15,  1 ), ;
                                    val( substr( c, 19,  3 ) ), ;
                                    val( substr( c, 27,  2 ) ) } )
          next
          ::lEndExec = .t.

     case oPbt:nId == ID_nCANCEL
          ::aaResult = {}
          ::lEndExec = .t.
   endcase
            
return            
                  
//----------------------------------------------------------------------------//

METHOD function DmdError( nMsg, o )
   local cMsg
   
   do case 
      case nMsg == ERR_nEXIST
           cMsg = "Nombre del campo repetido"
      case nMsg == ERR_nEMPTY
           cMsg = "Debe introducir un valor"
      case nMsg == ERR_nBADTYPE  
           cMsg = "El tipo es incorrecto"
      case nMsg == ERR_nNOTVALID
           cMsg = "La longitud debe ser mayor de 0"
      case nMsg == ERR_nCHARTOOLONG
           cMsg = "Los campos de tipo car cter no puden ser mayores de 254"
      case nMsg == ERR_nNUMTOOLONG
           cMsg = "Los campos de tipo n£merico no puden ser mayores de 19"
      case nMsg == ERR_nDECTOOSMALL
           cMsg = "La diferencia entre los d¡gitos debe ser de 2"
      case nMsg == ERR_nDECTOOLONG
           cMsg = "Los decimales no pueden ser m s de 15"
   endcase

   ::SetFocus( .f. )
   
   @ 24, 1 say "Error : "+cMsg color ::cClrMessage
   tone( 300, 2 )
   nMKeyWait()
   @ 24, 1 say space( 7 + len( cMsg ) ) color ::cClrMessage

   ::ChangeFocus( o )

return .f.             
        
//----------------------------------------------------------------------------//

METHOD function lDmdChkData()
   local lErr := .t.
   local c
   local n   

   do while .t.

      /* nombre del campo */

      n := ascan( ::lbxFields:acItems, ; 
                { |x| upper( trim( substr( x, 1, 10 ) ) ) = upper( trim ( ::edtName:cText )  ) } )
      if n != 0 
         lErr = ::Error( ERR_nEXIST, ::edtName )
         exit   
      endif
      if empty( ::edtName:cText )
         lErr = ::Error( ERR_nEMPTY, ::edtName ) 
         exit
      endif

      /* tipo del campo */

      ::cbxType:SetText( upper( ::cbxType:cText ) )

      if at( ::cbxType:cText, "CNLDM" ) == 0
         lErr = ::Error( ERR_nBADTYPE, ::cbxType )
         exit
      endif

      /* longitud */

      if val( ::edtLen:cText ) <= 0
         lErr = ::Error( ERR_nNOTVALID, ::edtLen ) 
         exit
       elseif ( ::cbxType:cText == "C" ) .and. val( ::edtLen:cText ) > 254  
         lErr = ::Error( ERR_nCHARTOOLONG, ::edtLen )
         exit
       elseif ( ::cbxType:cText == "N" ) .and. val( ::edtLen:cText ) > 19
         lErr = ::Error( ERR_nNUMTOOLONG, ::edtLen )
         exit   
      endif

      /* decimales */      
           
      if val( ::edtDec:cText ) > 0 .and. val( ::edtLen:cText ) - ;
                                         val( ::edtDec:cText ) < 2
         lErr = ::Error( ERR_nDECTOOSMALL, ::edtDec )
         exit
      elseif val( ::edtDec:cText ) > 15
         lErr = ::Error( ERR_nDECTOOLONG, ::edtDec )
         exit   
      endif       

      exit

   enddo

return lErr
        
//----------------------------------------------------------------------------//

METHOD function aaDmdExec()

   ::Exec()

return ::aaResult
        
//----------------------------------------------------------------------------//

