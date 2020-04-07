/************************************************************************
 Fichero..: D_CALC.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgCalc
 Fecha....: 05-18-92 10:10pm
 Versi¢n..: 1.00
 Notas....: Jugando con los Botones...
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

/*
 * Identificadores de los objetos
 */
#define ID_nELCD         1
#define ID_nB1           2
#define ID_nB2           3
#define ID_nB3           4
#define ID_nB4           5
#define ID_nB5           6
#define ID_nB6           7
#define ID_nB7           8
#define ID_nB8           9
#define ID_nB9           10
#define ID_nB0           11
#define ID_nBDEC         12
#define ID_nBRES         13

#define ID_nBADD         1
#define ID_nBSUB         2
#define ID_nBMUL         3
#define ID_nBDIV         4

/*
 * Operaciones, L¡mites y Errores 
 */
#define OP_nADD          1
#define OP_nSUB          2
#define OP_nMUL          3
#define OP_nDIV          4

#define MAX_nNUM         999999999
#define MIN_nNUM         -99999999

#define ERR_cOVERFLOW    "ERROR"

//----------------------------------------------------------------------------//

function Main()
 
 local dcalcTest := DlgCalc():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgCalc - Test", 79 ) color "GR+/B"

   dcalcTest:Exec()
   dcalcTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgCalc FROM Dialog

   VAR edtLcd                         /* pantalla                    */
   VAR pbt1                           /* botones n£mericos           */
   VAR pbt2                           
   VAR pbt3                           
   VAR pbt4                           
   VAR pbt5                         
   VAR pbt6                         
   VAR pbt7                         
   VAR pbt8                         
   VAR pbt9                         
   VAR pbt0                         
   VAR pbtDec                         /* punto decimal               */
   VAR pbtRes                         /* resultado =                 */
   VAR pbtAdd                         /* Suma                        */
   VAR pbtSub                         /* Resta                       */
   VAR pbtMul                         /* Multiplicaci¢n              */
   VAR pbtDiv                         /* Divisi¢n                    */

   VAR nOper                          /* Operando                    */   
   VAR nMakeOp                        /* Operador                    */
   VAR lFlagDec                       /* Hay decimal                 */
   VAR lNextOper                      /* Flag operaci¢n              */

   METHOD New          = DcalNew                /* constructor */
   METHOD PbtClick     = DcalPbtClick
   METHOD KeyPressed   = DcalEdtKeyPressed

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DcalNew()

   ::Parent:New( 4, 15, 16, 38, "Calculadora" )

   ::edtLcd    = Edit():New( 2, 3, 13, "", ID_nELCD, "", "" )

   ::pbt7      = PushButton():New(  4,  2, " 7 ", ID_nB7,    "" )
   ::pbt8      = PushButton():New(  4,  7, " 8 ", ID_nB8,    "" )
   ::pbt9      = PushButton():New(  4, 12, " 9 ", ID_nB9,    "" )
   ::pbtAdd    = PushButton():New(  4, 17, " + ", ID_nBADD,  "" )
   ::pbt4      = PushButton():New(  6,  2, " 4 ", ID_nB4,    "" )
   ::pbt5      = PushButton():New(  6,  7, " 5 ", ID_nB5,    "" )
   ::pbt6      = PushButton():New(  6, 12, " 6 ", ID_nB6,    "" )
   ::pbtSub    = PushButton():New(  6, 17, " - ", ID_nBSUB,  "" )
   ::pbt1      = PushButton():New(  8,  2, " 1 ", ID_nB1,    "" )
   ::pbt2      = PushButton():New(  8,  7, " 2 ", ID_nB2,    "" )
   ::pbt3      = PushButton():New(  8, 12, " 3 ", ID_nB3,    "" )
   ::pbtMul    = PushButton():New(  8, 17, " x ", ID_nBMUL,  "" )
   ::pbt0      = PushButton():New( 10,  2, " 0 ", ID_nB0,    "" )
   ::pbtDec    = PushButton():New( 10,  7, " . ", ID_nBDEC,  "" )
   ::pbtRes    = PushButton():New( 10, 12, " = ", ID_nBRES,  "" )
   ::pbtDiv    = PushButton():New( 10, 17, " / ", ID_nBDIV,  "" )

   /* inicializa instance vars */

   ::nOper     = 0
   ::lFlagDec  = .t.
   ::nMakeOp   = 0
   ::lNextOper = .f.

   ::edtLcd:cText = padl( 0, 13 )

   /* distinguir botones */
   
   ::pbtAdd:cClrNormal = "bg+/b"
   ::pbtSub:cClrNormal = "bg+/b"
   ::pbtMul:cClrNormal = "bg+/b"
   ::pbtDiv:cClrNormal = "bg+/b"
   ::pbtRes:cClrNormal = "w+/b"

   /* a¤ade los controles */

   ::AddControl( ::edtLcd )
   ::AddControl( ::pbt7   )
   ::AddControl( ::pbt8   )
   ::AddControl( ::pbt9   )
   ::AddControl( ::pbtAdd )
   ::AddControl( ::pbt4   )
   ::AddControl( ::pbt5   )
   ::AddControl( ::pbt6   )
   ::AddControl( ::pbtSub )
   ::AddControl( ::pbt1   )
   ::AddControl( ::pbt2   )
   ::AddControl( ::pbt3   )
   ::AddControl( ::pbtMul )
   ::AddControl( ::pbt0   )
   ::AddControl( ::pbtDec )
   ::AddControl( ::pbtRes )
   ::AddControl( ::pbtDiv )

return Self

//----------------------------------------------------------------------------//

METHOD function DcalPbtClick( Pbt )

   /* operaciones posibles */

   static aOp := { { { |x,y| x + y }, "+" },;
                   { { |x,y| x - y }, "-" },;
                   { { |x,y| x * y }, "x" },;
                   { { |x,y| x / y }, "/" } }

   /* cada bot¢n n£merico pulsado, env¡a su n£mero a la pantalla */

   do case
      case Pbt:nId == ID_nB0
         ::edtLcd:cText += "0"

      case Pbt:nId == ID_nB1
         ::edtLcd:cText += "1"

      case Pbt:nId == ID_nB2
         ::edtLcd:cText += "2"

      case Pbt:nId == ID_nB3
         ::edtLcd:cText += "3"

      case Pbt:nId == ID_nB4
         ::edtLcd:cText += "4"

      case Pbt:nId == ID_nB5
         ::edtLcd:cText += "5"

      case Pbt:nId == ID_nB6
         ::edtLcd:cText += "6"

      case Pbt:nId == ID_nB7
         ::edtLcd:cText += "7"

      case Pbt:nId == ID_nB8
         ::edtLcd:cText += "8"

      case Pbt:nId == ID_nB9
         ::edtLcd:cText += "9"

      case Pbt:nId == ID_nBDEC

         /* si se puede poner punto decimal lo ponemos */
         
         if ::lFlagDec
            ::edtLcd:cText += "."
            ::lFlagDec = !::lFlagDec
         endif

      case Pbt:nId == ID_nBRES

         /* alguna operaci¢n pendiente */

         if ::nMakeOp != 0 .and. ::nOper != 0  .and.  !empty( ::edtLcd:cText )

            /* calcular */
             
            ::nOper = eval( aOp[ ::nMakeOp, 1 ], ::nOper, val( ::edtLcd:cText ) )

            /* se ha realizado operaci¢n */

            ::lNextOper = .t.

            /* ¨ fuera de los l¡mites ? */

            if ::nOper > MAX_nNUM .or. ::nOper < MIN_nNUM
               ::nOper = 0
               ::edtLcd:SetText( ERR_cOVERFLOW )
            endif
      
         endif
         ::lFlagDec = .t.

         /* ponemos el resultado en la pantalla */

         ::edtLcd:cText = str( ::nOper )


      case Pbt:nId >= ID_nBADD .and. Pbt:nId <= ID_nBDIV         

         /* si no disponemos de 1er operando ya lo tenemos */

         if ::nOper == 0
            ::nOper = val( ::edtLcd:cText )
            ::edtLcd:cText = str( ::nOper )
         else
            
            /* si este es el 2do operando, ya podemos operar */

            ::nOper = eval( aOp[ ::nMakeOp, 1 ], ;
                            ::nOper, iif( val( ::edtLcd:cText ) == 0, 1, val( ::edtLcd:cText ) ) )

            /* ¨ fuera de los l¡mites ? */

            if ::nOper > MAX_nNUM .or. ::nOper < MIN_nNUM
               ::nOper = 0
               ::edtLcd:SetText( ERR_cOVERFLOW )
            endif

         endif

         /* proxima operaci¢n */

         ::nMakeOp = Pbt:nId

         /* ponemos el resultado en pantalla */

         ::edtLcd:cText = str( ::nOper )

         ::lFlagDec     = .t.
         ::lNextOper    = .t.

         /* visualizamos la siguiente operaci¢n */
         
         ::Say( 2, 21, aOp[ ::nMakeOp, 2 ], "n/w" )

   endcase
 
   /* ponemos el resultado ajustado y visualizamos */
      
   ::edtLcd:cText = padl( val( ::edtLcd:cText ), 13 )

   ::edtLcd:display()

   /* si hay proximo operador, la pantalla estar  visualizando un resultado
    * en espera de un oprerador                                             
    */

   if ::lNextOper
      ::edtLcd:cText = ""
      ::lNextOper    = .f.
   endif

return

//----------------------------------------------------------------------------//

/* un poco de estetica, para cuando se pulse el teclado */ 

METHOD function DcalEdtKeyPressed( nKey )
 local o

 /* asociamos las teclas con los push buttons */ 

 local aValidKeys := { { 48, ::pbt0   },;
                       { 49, ::pbt1   },;
                       { 50, ::pbt2   },;
                       { 51, ::pbt3   },;
                       { 52, ::pbt4   },;
                       { 53, ::pbt5   },;
                       { 54, ::pbt6   },;
                       { 55, ::pbt7   },;
                       { 56, ::pbt8   },;
                       { 57, ::pbt9   },;
                       { 42, ::pbtMul },;
                       { 43, ::pbtAdd },;
                       { 45, ::pbtSub },;
                       { 46, ::pbtDec },;
                       { 47, ::pbtDiv },;
                       { 61, ::pbtRes },;
                       { 13, ::pbtRes } }

 /* Comprobamos la tecla que se ha pulsado y enviamos el mensaje de pulsado
  * a su bot¢n correspondiente, el cual se encargar  de introducir en la 
  * pantalla, el n£mero pulsado. 
  * Si la tecla no nos es valida, la enviamos a la clase padre.
  */

 aeval( aValidKeys, { |x| o := iif( x[1] == nKey, x[2], o ) } )
 if o != NIL
    ::ChangeFocus( o )
    o:Click()
 else
    ::Parent:KeyPressed( nKey )
 endif

return
