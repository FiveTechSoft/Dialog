/************************************************************************
 Fichero..: D_STSSET.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgStsSet
 Fecha....: 05-20-92 11:32pm
 Versi¢n..: 1.00
 Notas....: Sets al gusto con lActive, ­Cambiar los Sets ya no es problema! 
 Autor....: Carlos Segura Sanz
************************************************************************/


#include "dialog.ch"

#define ID_nSETS      1
#define ID_nLOGICAL   2
#define ID_nCHAR      3
#define ID_nNUM       4
#define ID_nOK        5
#define ID_nCANCEL    6

//----------------------------------------------------------------------------//

function Main()

   local dssTest := DlgStsSets():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgStsTest - Test", 79 ) color "gr+/b"

   dssTest:Exec() 
   dssTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgStsSets FROM Dialog

   VAR lbxSets
   VAR rbmLogical
   VAR edtChar
   VAR edtNum
   VAR aSets
   VAR aOldSets
   VAR xVal
   VAR cType
   VAR pbtOk
   VAR pbtCancel

   METHOD New           = DssNew
   METHOD PbtClick      = DssPbtClick
   METHOD LbxSelect     = DssLbxSelect
   METHOD CtrlGotFocus  = DssCtrlGotFocus
   METHOD CtrlLostFocus = DssCtrlLostFocus
   METHOD Init          = DssInit

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DssNew()

   ::Parent:New( 4, 15, 19, 55, "Estado de los Sets" )
   
   ::lbxSets    = ListBox():New( 2, 3, 14, 18, ;
                                "&Sets", ;
                                ID_nSETS, ;
                                " Seleccione el Set " )

   ::rbmLogical = RbMenu():New( 2, 20, ;
                               "&Activo/Incativo", ;
                               ID_nLOGICAL, ;
                               "Seleccione Activo/Inactivo" )
   
   ::edtChar = Edit():New( 6, 20, 15, ;
                           "", ;
                           ID_nCHAR, ;
                           "&Cadena", ;
                           "Cadena de Car cteres" )
                              
   ::edtNum  = Edit():New( 9, 20, 15, ;
                           "", ;
                           ID_nNUM, ;
                           "&Valor", ;
                           "Valor del Set" )
   
   ::pbtOk     = PushButton():New( 11, 26, ;
                                   "    &Ok    ",;
                                   ID_nOK, ;
                                   " Continuar " )

   ::pbtCancel = PushButton():New( 13, 26, ;
                                   "  &Cancel  ", ;
                                   ID_nCANCEL, ;
                                   " Cancelar " )

   ::lbxSets:acItems = {  ;
                            "SET_EXACT      ", ; 
                            "SET_FIXED      ", ; 
                            "SET_DECIMALS   ", ; 
                            "SET_DATEFORMAT ", ; 
                            "SET_EPOCH      ", ; 
                            "SET_PATH       ", ; 
                            "SET_DEFAULT    ", ; 
                            "SET_EXCLUSIVE  ", ; 
                            "SET_SOFTSEEK   ", ; 
                            "SET_UNIQUE     ", ; 
                            "SET_DELETED    ", ; 
                            "SET_CANCEL     ", ; 
                            "SET_DEBUG      ", ; 
                            "SET_TYPEAHEAD  ", ; 
                            "SET_COLOR      ", ; 
                            "SET_CURSOR     ", ; 
                            "SET_CONSOLE    ", ; 
                            "SET_ALTERNATE  ", ; 
                            "SET_ALTFILE    ", ; 
                            "SET_DEVICE     ", ; 
                            "SET_EXTRA      ", ; 
                            "SET_EXTRAFILE  ", ; 
                            "SET_PRINTER    ", ; 
                            "SET_PRINTFILE  ", ; 
                            "SET_MARGIN     ", ; 
                            "SET_BELL       ", ; 
                            "SET_CONFIRM    ", ; 
                            "SET_ESCAPE     ", ; 
                            "SET_INSERT     ", ; 
                            "SET_EXIT       ", ; 
                            "SET_INTENSITY  ", ; 
                            "SET_SCOREBOARD ", ; 
                            "SET_DELIMITERS ", ; 
                            "SET_DELIMCHARS ", ; 
                            "SET_WRAP       ", ;
                            "SET_MESSAGE    ", ;
                            "SET_MCENTER    ", ;
                            "SET_SCROLLBREAK", ;
                            "SET_COUNT      "  }
    
   ::rbmLogical:AddItem( "Activo   .T." )
   ::rbmLogical:AddItem( "Inactivo .F." )

   ::aOldSets = {} 

   ::edtChar:nMaxLen = 25

   ::AddControl( ::lbxSets    )
   ::AddControl( ::rbmLogical )
   ::AddControl( ::edtChar    )
   ::AddControl( ::edtNum     )
   ::AddControl( ::pbtOk      )
   ::AddControl( ::pbtCancel  )   

return Self
    
//----------------------------------------------------------------------------//

METHOD function DssInit()
   local n

   for n = 1 to len( ::lbxSets:acItems )
       aadd( ::aOldSets, set( n ) )
   next

return 

//----------------------------------------------------------------------------//

METHOD function DssLbxSelect( oListBox )
    
   ::xVal  := set( oListBox:nOption )    
   ::cType := valtype( ::xVal )

   do case
      case ::cType == "C"
           ::edtChar:SetText( ::xVal )
           ::edtNum:SetText( padl( 0, 15 )  )
           ::rbmLogical:SetOption( 0 )
           ::edtChar:lActive    = .t.
           ::edtNum:lActive     = .f.
           ::rbmLogical:lActive = .f.
      case ::cType == "N"
           ::edtChar:SetText( "" )
           ::edtNum:SetText( padl( ::xVal, 15 ) )
           ::rbmLogical:SetOption( 0 )
           ::edtChar:lActive    = .f.
           ::edtNum:lActive     = .t.
           ::rbmLogical:lActive = .f.
      case ::cType == "L"
           ::edtChar:SetText( ""  )
           ::edtNum:SetText( padl( 0, 15 ) )
           ::rbmLogical:SetOption( iif( ::xVal, 1, 2 ) )
           ::edtChar:lActive    = .f.
           ::edtNum:lActive     = .f.
           ::rbmLogical:lActive = .t.
   endcase

return 

//----------------------------------------------------------------------------//

METHOD function DssCtrlGotFocus( oCtrl )

   local nId := oCtrl:nId
   /*
   do case
      case nId == ID_nSETS .or. nId == ID_nOK .or. nId == ID_nCANCEL
      case ::cType == "C" .and. nId != ID_nCHAR
           ::SetFocus( .f. )
           ::ChangeFocus( ::edtNum )
      case ::cType == "N" .and. nId != ID_nNUM
           ::SetFocus( .f. )
           ::ChangeFocus( ::rbmLogical )
      case ::cType == "L" .and. nId != ID_nLOGICAL
           ::SetFocus( .f. )
           ::ChangeFocus( ::edtChar )
   endcase
   */
return

//----------------------------------------------------------------------------//

METHOD function DssCtrlLostFocus( oCtrl )

  local n := ::lbxSets:nOption

  do case
     case oCtrl:nId == ID_nLOGICAL
          set( n, iif( ::rbmLogical:nOPtion == 1, .t., .f. ) )
     case oCtrl:nId == ID_nCHAR 
          set( n, ::edtChar:cText )
     case oCtrl:nId == ID_nNUM
          set( n, val( ::edtNum:cText ) )
  endcase
                           
return 

//----------------------------------------------------------------------------//

METHOD function DssPbtClick( oPbt )
  local n

  do case
     case oPbt:nId == ID_nOK
          ::lEndExec = .t.
     case oPbt:nId == ID_nCANCEL
          for n = 1 to len( ::lbxSets:acItems )
              set( n, ::aOldSets[ n ] )
          next
          ::lEndExec = .t.
  endcase        

return 
