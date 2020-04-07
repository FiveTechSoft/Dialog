/************************************************************************
 Fichero..: D_TIME.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgTime
 Fecha....: 05-20-92 04:50am
 Versi¢n..: 1.00
 Notas....: Dialog ­ Ya era hora !
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nHOUR        1
#define ID_nMIN         2
#define ID_nSEC         3
#define ID_nADJHOUR     4
#define ID_nADJMIN      5
#define ID_nADJSEC      6
#define ID_nOK          7
#define ID_nCANCEL      8

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTime():New()
   local cTime

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( " DlgTime - Test ", 79 ) color "gr+/b"

   alert( dlgTest:cExec() )
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTime FROM Dialog

   VAR sbrHour
   VAR sbrMin
   VAR sbrSec
   VAR pbtHour
   VAR pbtMin
   VAR pbtSec
   VAR pbtOk
   VAR pbtCancel
   VAR cResult

   METHOD New          = DtNew
   METHOD Init         = DtInit
   METHOD SbrUp        = DtSbrUp
   METHOD SbrDown      = DtSbrDown
   METHOD SbrPgUp      = DtSbrPgUp
   METHOD SbrPgDown    = DtSbrPgDown
   METHOD PbtClick     = DtPbtClick
   METHOD cExec        = cDtExec

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtNew()

   ::Parent:New( 4, 13, 17, 64, "¨ Que Hora Es ?" )

   ::pbtHour   = PushButton():New(  2, 5, ;
                                   padc( substr( time(), 1, 2 ), 4 ) , ;
                                   ID_nHOUR,;
                                   "" )

   ::pbtMin    = PushButton():New(  2, 13, ;
                                   padc( substr( time(), 4, 2 ), 4 ), ;
                                   ID_nMIN,;
                                   "" )

   ::pbtSec    = PushButton():New(  2, 21, ;
                                   padc( substr( time(), 7, 2 ), 4 ), ;
                                   ID_nMIN,;
                                   "" )

   ::sbrHour = ScrollBar():New( 5, 7, 20, ;
                                "&Horas", ;
                                ID_nADJHOUR, ;
                                " Ajuste de Horas ", ;
                                .t. )

   ::sbrMin  = ScrollBar():New( 8, 7, 20, ;
                                "&Minutos", ;
                                ID_nADJMIN, ;
                                " Ajuste de minutos ", ;
                                .t. )

   ::sbrSec  = ScrollBar():New( 11, 7, 20, ;
                                "&Segundos", ;
                                ID_nADJSEC, ;
                                " Ajuste de segundos ", ;
                                .t. )

   ::pbtOk     = PushButton():New(  7, 35, ;
                                   "     &Ok     ", ;
                                   ID_nOK,;
                                   " Fijar estos nuevos valores " )

   ::pbtCancel = PushButton():New( 10, 35, ;
                                   "   &Cancel   ", ;
                                   ID_nCANCEL, ;
                                   " Resetear a los valores iniciales " )


   ::sbrHour:nValue  = val( substr( time(), 1, 2 ) )
   ::sbrMin:nValue   = val( substr( time(), 4, 2 ) )
   ::sbrSec:nValue   = val( substr( time(), 7, 2 ) )
   ::sbrHour:nRange  = 24
   ::sbrMin:nRange   = 59
   ::sbrSec:nRange   = 59

   ::cResult = ""

   ::pbtHour:cClrNormal = "bg+/b"
   ::pbtMin:cClrNormal  = "bg+/b"
   ::pbtSec:cClrNormal  = "bg+/b"

   ::AddControl( ::sbrHour  )
   ::AddControl( ::sbrMin   )
   ::AddControl( ::sbrSec   )
   ::AddControl( ::pbtHour  )
   ::AddControl( ::pbtMin   )
   ::AddControl( ::pbtSec   )
   ::AddControl( ::pbtOk    )
   ::AddControl( ::pbtCancel)

return Self

//----------------------------------------------------------------------------//

METHOD function DtInit()

   ::Say(  5,  5, "0"  )
   ::Say(  5, 28, "24" )
   ::Say(  8,  5, "0"  )
   ::Say(  8, 28, "59" )
   ::Say( 11,  5, "0"  )
   ::Say( 11, 28, "59" )

   ::sbrHour:ThmCheck()
   ::sbrMin:ThmCheck()
   ::sbrSec:ThmCheck()
   
   ::pbtHour:lActive = .f.
   ::pbtMin:lActive  = .f.
   ::pbtSec:lActive  = .f.

return

//----------------------------------------------------------------------------//

METHOD function DtSbrUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue--
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtSbrDown( oScrollBar )
              
   if oScrollBar:nValue < oScrollBar:nRange
      oScrollBar:nValue++
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtSbrPgUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue = Max( oScrollBar:nValue - 10, 0 )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtSbrPgDown( oScrollBar )

   if oScrollBar:nValue < oScrollBar:nRange
      oScrollBar:nValue = Min( oScrollBar:nValue + 10, oScrollBar:nRange )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

static function SbrDispValue( oObject, oScrollBar )

   do case
      case oScrollBar:nId == ID_nADJHOUR
           oObject:pbtHour:cText = padc( oScrollBar:nValue, 4 )
           oObject:pbtHour:lActive = .t. 
           oObject:pbtHour:Display()
           oObject:pbtHour:lActive = .f. 

      case oScrollBar:nId == ID_nADJMIN
           oObject:pbtMin:cText = padc( oScrollBar:nValue, 4 )
           oObject:pbtMin:lActive = .t.
           oObject:pbtMin:Display()
           oObject:pbtMin:lActive = .f.

      case oScrollBar:nId == ID_nADJSEC
           oObject:pbtSec:cText = padc( oScrollBar:nValue, 4 )
           oObject:pbtSec:lActive = .t.
           oObject:pbtSec:Display()
           oObject:pbtSec:lActive = .f.

   endcase

return

//----------------------------------------------------------------------------//

METHOD function DtPbtClick( oPushButton )
   local n

   do case
      case oPushButton:nId == ID_nOK
           ::cResult = str( ::sbrHour:nValue, 2 ) + ":" +;
                       str( ::sbrMin:nValue,  2 ) + ":" +;
                       str( ::sbrSec:nValue,  2 )
           ::lEndExec = .t.
      case oPushButton:nId == ID_nCANCEL
           ::cResult = ""
           ::lEndExec = .t.
   endcase

return

//----------------------------------------------------------------------------//

METHOD function cDtExec()

 ::Exec()

return ::cResult





