// Pruebas BetaTest realizadas por Francisco Morero

#include "dialog.ch"

#define ID_nFLDNAME    1
#define ID_nSEARCH     2
#define ID_nSCOPE      3
#define ID_nRUN        4
#define ID_nVIEW       5
#define ID_nFIN        6
#define ID_nFILES      7

//----------------------------------------------------------------------------//

function Main()

   local dffTest := DlgFF():New()

   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dffTest:Exec()
   dffTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgFF FROM Dialog

   VAR edtFldName, edtSearch
   VAR pbtRun, pbtView, pbtFin
   VAR rbmScope
   VAR lbxFiles

   METHOD New           = DffNew
   METHOD Init          = DffInit
   METHOD PbtClick      = DffPbtClick
   METHOD CtrlGotFocus  = DffCtrlGotFocus
   METHOD LbxChoosed    = DffLbxChoosed

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DffNew()

   ::Parent:New( 1, 6, 21, 73, "Buscar Ficheros" )

   ::edtFldName = Edit():New( 2, 13, 51, "*.*", ID_nFLDNAME, "&Fichero",;
                  " Especifique un fichero o un patr¢n de b£squeda " )
   ::edtSearch  = Edit():New( 4, 13, 51, "", ID_nSEARCH, "&Buscar",;
                  " Secuencia que deben contener los ficheros " )
   ::rbmScope   = RbMenu():New( 7, 3, "&Donde buscar", ID_nSCOPE,;
                  " En donde buscar", .f. )
   ::pbtRun     = PushButton():New( 12, 3, " &Buscar ", ID_nRUN,;
                  " Comenzar la b£squeda " )
   ::pbtView    = PushButton():New( 15, 3, "   &Ver  ", ID_nVIEW,;
                  " Visualizar el contenido del fichero " )
   ::pbtFin     = PushButton():New( 18, 3, " &Salir  ", ID_nFIN,;
                  " Fin de la aplicaci¢n " )
   ::lbxFiles   = ListBox():New( 12, 14, 18, 63, "Fi&cheros", ID_nFILES,;
                  " Elija un fichero " )

   ::edtFldName:oLabel:Move( 0, -10 )
   ::edtSearch:oLabel:Move( 0, -10 )

   ::rbmScope:AddItem( "En &todo el disco" )
   ::rbmScope:AddItem( "Desde el directorio &actual en adelante" )
   ::rbmScope:AddItem( "&Solo en el directorio actual" )

   ::pbtRun:lDefault = .t.
   ::pbtView:lActive = .f.

   ::AddControl( ::edtFldName )
   ::AddControl( ::edtSearch )
   ::AddControl( ::rbmScope )
   ::AddControl( ::pbtRun )
   ::AddControl( ::pbtView )
   ::AddControl( ::pbtFin )
   ::AddControl( ::lbxFiles )

return Self

//----------------------------------------------------------------------------//

METHOD function DffInit()

   local nRowOld := Row()
   local nColOld := Col()

   SetCursor( 0 )
   ::Say( 19, 16, "Directorio: " )
   SetCursor( 1 )
   @ nRowOld, nColOld SAY ""

return

//----------------------------------------------------------------------------//

METHOD function DffPbtClick( oPbt )

   do case
      case oPbt:nId == ID_nRUN
           if ! Empty( ::edtFldName:cText )
              ::lbxFiles:acItems = aDirectorio( ::edtFldName:cText )
              ::pbtRun:lDefault  = .f.
              ::pbtView:lActive  = .t.
              ::pbtView:lDefault = .t.
              ::pbtFin:lActive   = .t.
              ::lbxFiles:Display()
              ::pbtRun:Display()
              ::pbtView:Display()
              ::pbtFin:Display()
              ::Say( 19, 28, ::edtFldName:cText, "RB/W" )
              ::ChangeFocus( ::lbxFiles )
           endif

      ////case oPbt:nId == ID_nVer

      case oPbt:nId == ID_nFIN
           ::EndExec()
   endcase

return

//-------------------------------------------------------------------------

METHOD function DffCtrlGotFocus( oControl )

   if oControl:ClassName() != "PUSHBUTTON"
      if Len( ::lbxFiles:acItems ) > 0
         ::pbtView:lDefault = .t.
         ::pbtView:Display()
      else
         ::pbtRun:lDefault = .t.
         ::pbtRun:Display()
      endif

   else
      do case
         case oControl:nId == ID_nRUN
              ::pbtView:lDefault  = .f.
              ::pbtFin:lDefault = .f.
              ::pbtView:Display()
              ::pbtFin:Display()

         case oControl:nId == ID_nVIEW
              ::pbtRun:lDefault  = .f.
              ::pbtFin:lDefault = .f.
              ::pbtRun:Display()
              ::pbtFin:Display()

         case oControl:nId == ID_nFIN
              ::pbtRun:lDefault  = .f.
              ::pbtView:lDefault = .f.
              ::pbtRun:Display()
              ::pbtView:Display()
      endcase
   endif

return

//-------------------------------------------------------------------------

static func aDirectorio( cPath )

local aDIn := directory( cPath )
local aDOut:= {}, i

   for i = 1 TO len( aDIn )
      aadd( aDOut, " " + pad( aDIn[i][1], 12 ) + " ³ " + str( aDIn[i][2], 6 ) +;
          " ³ " + dtoc( aDIn[i][3] ) + " ³ " + aDIn[i][4] + " ³ " + aDIn[i][5] )
   next

return aDOut

//----------------------------------------------------------------------------//

METHOD function DffLbxChoosed( oLbx )

   Alert( "Doble Click" )

return

//----------------------------------------------------------------------------//
