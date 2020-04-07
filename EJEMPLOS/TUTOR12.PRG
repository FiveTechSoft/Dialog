#include "dialog.ch"

#define ID_nVOLUMEN    100
#define ID_nINTENSIDAD 200
#define ID_nTONO       300
#define ID_nDIGITAL    400
#define ID_nESTABLECER 500
#define ID_nCANCELAR   600

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTest():New()

   AltD( 0 )
   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR sbrVolumen, sbrIntensidad, sbrTono
   VAR cbtDigital
   VAR pbtEstablecer, pbtCancelar

   METHOD New          = DtsNew
   METHOD Init         = DtsInit
   METHOD SbrUp        = DtsSbrUp
   METHOD SbrDown      = DtsSbrDown
   METHOD SbrPgUp      = DtsSbrPgUp
   METHOD SbrPgDown    = DtsSbrPgDown
   METHOD CtrlGotFocus = DtsCtrlGotFocus
   METHOD PbtClick     = DtsPbtClick

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 4, 13, 17, 64, "Control de Sonido" )

   ::sbrVolumen    = ScrollBar():New(  4, 7, 20, "&Volumen", ID_nVOLUMEN,;
                                      " Control del Volumen ", .t. )
   ::sbrIntensidad = ScrollBar():New(  7, 7, 20, "&Intensidad", ID_nINTENSIDAD,;
                                      " Control de la Intensidad ", .t. )
   ::sbrTono       = ScrollBar():New( 10, 7, 20, "&Tono", ID_nTONO,;
                                      " Control del Tono ", .t. )
   ::cbtDigital    = CheckBtn():New( 4, 35, "&Digital", ID_nDIGITAL,;
                                     " Sonido Digital " )
   ::pbtEstablecer = PushButton():New(  7, 35, " &Establecer ", ID_nESTABLECER,;
                                       " Fijar estos nuevos valores " )
   ::pbtCancelar   = PushButton():New( 10, 35, "  &Cancelar  ", ID_nCANCELAR,;
                                       " Resetear a los valores iniciales " )


   ::sbrVolumen:nValue    =   0
   ::sbrIntensidad:nValue =   0
   ::sbrTono:nValue       =   0
   ::sbrVolumen:nRange    = 100
   ::sbrIntensidad:nRange = 100
   ::sbrTono:nRange       = 100

   ::pbtEstablecer:lDefault = .t.

   ::AddControl( ::sbrVolumen )
   ::AddControl( ::sbrIntensidad )
   ::AddControl( ::sbrTono )
   ::AddControl( ::cbtDigital )
   ::AddControl( ::pbtEstablecer )
   ::AddControl( ::pbtCancelar )

return Self

//----------------------------------------------------------------------------//

METHOD function DtsInit()

   ::Say(  4,  5, "0" )
   ::Say(  4, 28, "100" )
   ::Say(  7,  5, "0" )
   ::Say(  7, 28, "100" )
   ::Say( 10,  5, "0" )
   ::Say( 10, 28, "100" )

   ::Say( 3, 20, Transform( ::sbrVolumen:nValue,    "999" ), "RB/W"  )
   ::Say( 6, 20, Transform( ::sbrIntensidad:nValue, "999" ), "RB/W"  )
   ::Say( 9, 20, Transform( ::sbrTono:nValue,       "999" ), "RB/W"  )

return

//----------------------------------------------------------------------------//

METHOD function DtsSbrUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue--
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtsSbrDown( oScrollBar )

   if oScrollBar:nValue < 100
      oScrollBar:nValue++
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtsSbrPgUp( oScrollBar )

   if oScrollBar:nValue > 0
      oScrollBar:nValue = Max( oScrollBar:nValue - 10, 0 )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtsSbrPgDown( oScrollBar )

   if oScrollBar:nValue < 100
      oScrollBar:nValue = Min( oScrollBar:nValue + 10, 100 )
      oScrollBar:ThmCheck()
   endif
   SbrDispValue( Self, oScrollBar )

return

//----------------------------------------------------------------------------//

METHOD function DtsCtrlGotFocus( oControl )

   if oControl:nId == ID_nCANCELAR
      ::pbtEstablecer:lDefault = .f.
      ::pbtEstablecer:Display()
   else
      if ! ::pbtEstablecer:lDefault
         ::pbtEstablecer:lDefault = .t.
         ::pbtEstablecer:Display()
      endif
   endif

return

//----------------------------------------------------------------------------//

static function SbrDispValue( oObject, oScrollBar )

   do case
      case oScrollBar:nId == ID_nVOLUMEN
           oObject:Say( 3, 20, Transform( oScrollBar:nValue, "999" ), "RB/W"  )

      case oScrollBar:nId == ID_nINTENSIDAD
           oObject:Say( 6, 20, Transform( oScrollBar:nValue, "999" ), "RB/W"  )

      case oScrollBar:nId == ID_nTONO
           oObject:Say( 9, 20, Transform( oScrollBar:nValue, "999" ), "RB/W"  )
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DtsPbtClick( oPushButton )

   if oPushButton:nId == ID_nESTABLECER
      ::EndExec()
   endif

return

//----------------------------------------------------------------------------//
