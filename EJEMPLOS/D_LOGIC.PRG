#include "dialog.ch"

#define ID_nCAMPOS     100
#define ID_nIGUAL      200
#define ID_nDISTINTO   300
#define ID_nY          400
#define ID_nMAS        500
#define ID_nMENOR      600
#define ID_nMAYOR      700
#define ID_nO          800
#define ID_nMENOS      900
#define ID_nMEIGUAL   1000
#define ID_nMAIGUAL   1100
#define ID_nNO        1200
#define ID_nPOR       1300
#define ID_nPARIZQ    1400
#define ID_nPARDER    1500
#define ID_nCONTENIDO 1600
#define ID_nDIVIDE    1700
#define ID_nLITERAL   1800
#define ID_nEXPRESION 1900
#define ID_nPREVIO    2000
#define ID_nSIGUIENTE 2100
#define ID_nOK        2200
#define ID_nBORRAR    2300
#define ID_nCANCELAR  2400

//----------------------------------------------------------------------------//

function Main()

   local dlcTest := DlgLogic():New()

   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlcTest:Exec()
   dlcTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgLogic FROM Dialog

   VAR lbxCampos
   VAR pbtIgual, pbtDistinto, pbtY, pbtMas
   VAR pbtMenor, pbtMayor, pbtO, pbtMenos
   VAR pbtMeIgual, pbtMaIgual, pbtNo, pbtPor
   VAR pbtParIzq, pbtParDer, pbtComo, pbtDivide
   VAR edtLiteral, edtExpresion
   VAR pbtPrevio, pbtSiguiente
   VAR pbtOk, pbtBorrar, pbtCancelar
   VAR nArea

   METHOD New      = DlcNew            // Constructor, obligatorio!
   METHOD Init     = DlcInit           // Redefinici¢n de m‚todo de Dialog
   METHOD PbtClick = DlcPbtClick       // Redefinici¢n de m‚todo de Dialog

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DlcNew()

   ::Parent:New( 3, 7, 18, 72, "Construya la Expresi¢n" )

   ::lbxCampos    = ListBox():New( 3, 2, 11, 15, "&Campos", ID_nCAMPOS,;
                                   " Campos disponibles " )
   ::pbtIgual     = PushButton():New( 3, 18, " == ", ID_nIGUAL,;
                                      " Igual a... " )
   ::pbtDistinto  = PushButton():New( 3, 24, " <> ", ID_nDISTINTO,;
                                      " Distinto de... " )
   ::pbtY         = PushButton():New( 3, 30, " .AND. ", ID_nY,;
                                      " y... " )
   ::pbtMas       = PushButton():New( 3, 39, " + ", ID_nMAS,;
                                      " M s... " )
   ::pbtMenor     = PushButton():New( 5, 18, " <  ", ID_nMENOR,;
                                      " Menor que... " )
   ::pbtMayor     = PushButton():New( 5, 24, " >  ", ID_nMAYOR,;
                                      " Mayor que... " )
   ::pbtO         = PushButton():New( 5, 30, " .OR.  ", ID_nO,;
                                      " ¢... " )
   ::pbtMenos     = PushButton():New( 5, 39, " - ", ID_nMENOR,;
                                      " Menos... " )
   ::pbtMeIgual   = PushButton():New( 7, 18, " <= ", ID_nMEIGUAL,;
                                      " Menor ¢ Igual que... " )
   ::pbtMaIgual   = PushButton():New( 7, 24, " >= ", ID_nMAIGUAL,;
                                      " Mayor ¢ Igual que... " )
   ::pbtNo        = PushButton():New( 7, 30, " .NOT. ", ID_nNO,;
                                      " No... " )
   ::pbtPor       = PushButton():New( 7, 39, " * ", ID_nPOR,;
                                      " Multiplicado por... " )
   ::pbtParIzq    = PushButton():New( 9, 18, " (  ", ID_nPARIZQ,;
                                      " Comenzar grupo... " )
   ::pbtParDer    = PushButton():New( 9, 24, " )  ", ID_nPARDER,;
                                      " Terminar grupo... " )
   ::pbtComo      = PushButton():New( 9, 30, "   $   ", ID_nCONTENIDO,;
                                      " Contenido en... " )
   ::pbtDivide    = PushButton():New( 9, 39, " / ", ID_nDIVIDE,;
                                      " Dividido por... " )
   ::edtLiteral   = Edit():New( 12, 18, 23, "", ID_nLITERAL, "&Literal",;
                                " Introduzca una expresi¢n literal " )
   ::edtExpresion = Edit():New( 14, 2, 60, "", ID_nEXPRESION, "&Expresi¢n",;
                                " Expresi¢n en construcci¢n " )
   ::pbtPrevio    = PushButton():New(  3, 47, " << ", ID_nPREVIO,;
                                      " Anterior " )
   ::pbtSiguiente = PushButton():New(  3, 57, " >> ", ID_nSIGUIENTE,;
                                      " Siguiente " )
   ::pbtOk        = PushButton():New(  8, 49, "    &Ok    ", ID_nOK,;
                                      " De acuerdo " )
   ::pbtBorrar    = PushButton():New( 10, 49, "  &Borrar  ", ID_nBORRAR,;
                                      " Borrar la expresi¢n " )
   ::pbtCancelar  = PushButton():New( 12, 49, " C&ancelar ", ID_nCANCELAR,;
                                      " Terminar la operaci¢n " )
   ::nArea        = 1

   ::pbtPrevio:cClrNormal    = "N/RB"
   ::pbtSiguiente:cClrNormal = "N/RB"

   ::AddControl( ::lbxCampos )
   ::AddControl( ::pbtIgual )
   ::AddControl( ::pbtDistinto )
   ::AddControl( ::pbtY )
   ::AddControl( ::pbtMas )
   ::AddControl( ::pbtMenor )
   ::AddControl( ::pbtMayor )
   ::AddControl( ::pbtO )
   ::AddControl( ::pbtMenos )
   ::AddControl( ::pbtMeIgual )
   ::AddControl( ::pbtMaIgual )
   ::AddControl( ::pbtNo )
   ::AddControl( ::pbtPor )
   ::AddControl( ::pbtParIzq )
   ::AddControl( ::pbtParDer )
   ::AddControl( ::pbtComo )
   ::AddControl( ::pbtDivide )
   ::AddControl( ::edtLiteral )
   ::AddControl( ::edtExpresion )
   ::AddControl( ::pbtPrevio )
   ::AddControl( ::pbtSiguiente )
   ::AddControl( ::pbtOk )
   ::AddControl( ::pbtBorrar )
   ::AddControl( ::pbtCancelar )

return Self

//----------------------------------------------------------------------------//

METHOD function DlcInit()

   ::Box( 2, 45, 6, 63 )
   ::Say( 2, 51, " Areas " )
   ::Say( 3, 53, Transform( ::nArea, "999" ) )

return

//----------------------------------------------------------------------------//

METHOD function DlcPbtClick( oPushButton )

   do case
      case oPushButton:nId == ID_nPREVIO
           if ::nArea > 1
              ::nArea--
              ::Say( 3, 53, Transform( ::nArea, "999" ) )
           else
              Tone( 900, 0.5 )
           endif

      case oPushButton:nId == ID_nSIGUIENTE
           if ::nArea < 256
              ::nArea++
              ::Say( 3, 53, Transform( ::nArea, "999" ) )
           else
              Tone( 900, 0.5 )
           endif

     case oPushButton:nId == ID_nCANCELAR
          ::EndExec()

   endcase
return

//----------------------------------------------------------------------------//
