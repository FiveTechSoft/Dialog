/************************************************************************
 Fichero..: D_SELTON.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgSelTon
 Fecha....: 05-19-92 08:08pm
 Versi¢n..: 1.00
 Notas....: ScrollBars para hacer musica. 
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nTONE         1
#define ID_nLONG         2
#define ID_nTIMES        3
#define ID_nTEST         4
#define ID_nOK           5
#define ID_nCANCEL       6

//----------------------------------------------------------------------------//

function Main()

   local dstTest := DlgSelTon():New()
   local aTone

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgSelTon - Test", 79 ) color "gr+/b"

   aTone = dstTest:aExec()

   if len( aTone ) = 3 
      alert( "Selecciono", { str( aTone[ 1 ] ), ;
                             str( aTone[ 2 ] ), ;
                             str( aTone[ 3 ] ) } )
   endif

   dstTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgSelTon FROM Dialog

   VAR sbrTone
   VAR sbrLong
   VAR sbrTimes
   VAR pbtTest
   VAR pbtOk
   VAR pbtCancel
   VAR aResult

   METHOD New          = DstNew
   METHOD Init         = DstInit
   METHOD SbrUp        = DstSbrUp
   METHOD SbrDown      = DstSbrDown
   METHOD SbrPgUp      = DstSbrPgUp
   METHOD SbrPgDown    = DstSbrPgDown
   METHOD PbtClick     = DstPbtClick
   METHOD aExec        = aDstExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DstNew()

   ::Parent:New( 4, 13, 17, 64, "Selecci¢n de la Campana" )

   ::sbrTone = ScrollBar():New( 4, 7, 20, ;
                                "&Tono", ;
                                ID_nTONE, ;
                                " Control del Tono ", ;
                                .t. )

   ::sbrLong = ScrollBar():New( 7, 7, 20, ;
                                "&Duraci¢n", ;
                                ID_nLONG, ;
                                " Control de la Duraci¢n ", ;
                                .t. )

   ::sbrTimes= ScrollBar():New( 10, 7, 20, ;
                                "&Veces", ;
                                ID_nTIMES, ;
                                " Veces que sonar  ", ;
                                .t. )

   ::pbtTest   = PushButton():New( 4, 35, ;
                                   "   &Probar   ", ;
                                   ID_nTEST, ;
                                   " Probar la campana " )

   ::pbtOk     = PushButton():New(  7, 35, ;
                                   "     &Ok     ", ;
                                   ID_nOK,;
                                   " Fijar estos nuevos valores " )

   ::pbtCancel = PushButton():New( 10, 35, ;
                                   "   &Cancel   ", ;
                                   ID_nCANCEL, ;
                                   " Resetear a los valores iniciales " )


   ::sbrTone:nValue  =    0
   ::sbrLong:nValue  =    0
   ::sbrTimes:nValue =    0
   ::sbrTone:nRange  = 1000
   ::sbrLong:nRange  =   50
   ::sbrTimes:nRange =   50

   ::pbtTest:lDefault = .t.

   ::aResult := {}

   ::AddControl( ::sbrTone  )
   ::AddControl( ::sbrLong  )
   ::AddControl( ::sbrTimes )
   ::AddControl( ::pbtTest  )
   ::AddControl( ::pbtOk    )
   ::AddControl( ::pbtCancel)

return Self

//----------------------------------------------------------------------------//

METHOD function DstInit()

   ::Say(  4,  5, "0" )
   ::Say(  4, 28, "1000" )
   ::Say(  7,  5, "0" )
   ::Say(  7, 28, "  50" )
   ::Say( 10,  5, "0" )
   ::Say( 10, 28, "  50" )

   ::Say( 3, 20, transform( ::sbrTone:nValue,    "9999" ), "rb/w"  )
   ::Say( 6, 20, transform( ::sbrLong:nValue,    "9999" ), "rb/w"  )
   ::Say( 9, 20, transform( ::sbrTimes:nValue,   "9999" ), "rb/w"  )

return

//----------------------------------------------------------------------------//

METHOD function DstSbrUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue--
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DstSbrDown( oScrollBar )
              
   if oScrollBar:nValue < oScrollBar:nRange
      oScrollBar:nValue++
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DstSbrPgUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue = Max( oScrollBar:nValue - 10, 0 )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DstSbrPgDown( oScrollBar )

   if oScrollBar:nValue < oScrollBar:nRange
      oScrollBar:nValue = Min( oScrollBar:nValue + 10, oScrollBar:nRange )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

static function SbrDispValue( oObject, oScrollBar )

   do case
      case oScrollBar:nId == ID_nTONE
           oObject:Say( 3, 20, transform( oScrollBar:nValue, "9999" ), "rb/w"  )

      case oScrollBar:nId == ID_nLONG
           oObject:Say( 6, 20, transform( oScrollBar:nValue, "9999" ), "rb/w"  )

      case oScrollBar:nId == ID_nTIMES
           oObject:Say( 9, 20, transform( oScrollBar:nValue, "9999" ), "rb/w"  )
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DstPbtClick( oPushButton )
   local n

   do case
      case oPushButton:nId == ID_nOK
           ::aResult = { ::sbrTone:nValue, ;
                         ::sbrLong:nValue, ;
                         ::sbrTimes:nValue }  
           ::lEndExec = .t.
      case oPushButton:nId == ID_nCANCEL
           ::aResult = {}
           ::lEndExec = .t.
      case oPushButton:nId == ID_nTEST
           for n = 1 to ::sbrTimes:nValue
               tone( ::sbrTone:nValue, ::sbrLong:nValue )
           next
   endcase

return

//----------------------------------------------------------------------------//

METHOD function aDstExec()

 ::Exec()

return ::aResult
