#include <dos.h>

/*----------------------------------------------------------------------------*/

enum Boolean { False, True };
typedef int Boolean;

static unsigned int uiMouseRow = 0, uiMouseCol = 0;
static unsigned int uiMouseGrafRow = 0, uiMouseGrafCol = 0;
static Boolean bMouseLeft, bMouseCenter, bMouseRight;
static Boolean bThereIsMouse = False;
static char cMouseButtons = 0;
static Boolean bMouseCursor = False;

/*----------------------------------------------------------------------------*/

void MouseInit()
{
   char cIsMouse;

   asm mov ax, 0;
   asm int 0x33;
   asm mov cIsMouse, al;
   asm mov cMouseButtons, bl;

   bThereIsMouse = ( cIsMouse == -1 );
   cMouseButtons = ( cMouseButtons == -1 ) ? 2: 3;
   bMouseCursor = False;
}

/*----------------------------------------------------------------------------*/

Boolean bIsMouse()
{
   if( ! bThereIsMouse )
       MouseInit();
   return bThereIsMouse;
}

/*----------------------------------------------------------------------------*/

void MouseSetCursor( Boolean bOnOff )
{
   if( bIsMouse() )
   {
      if( bOnOff )
      {
         if( ! bMouseCursor )
         {
            bMouseCursor = True;
            asm mov ax, 1;
            asm int 0x33;
         }
      }
      else
      {
         if( bMouseCursor )
         {
            bMouseCursor = False;
            asm mov ax, 2;
            asm int 0x33;
         }
      }
   }
}

/*----------------------------------------------------------------------------*/

char cMouseGetButtons()
{
   return cMouseButtons;
}

/*----------------------------------------------------------------------------*/

Boolean bMouseGetCursor()
{
   return bMouseCursor;
}

/*----------------------------------------------------------------------------*/

void MouseUpdate()
{
   char cButtonsPressed;
   unsigned int uiGrafRow;
   unsigned int uiGrafCol;

   if( bIsMouse() )
   {
      _AX             = 3;
      geninterrupt( 0x33 );
      uiGrafRow       = _DX;
      uiGrafCol       = _CX;
      cButtonsPressed = _BL;

      uiMouseGrafRow = uiGrafRow;
      uiMouseGrafCol = uiGrafCol;
      uiMouseRow     = uiGrafRow / 8;
      uiMouseCol     = uiGrafCol / 8;
      bMouseLeft     = cButtonsPressed & 1;
      bMouseCenter   = cButtonsPressed & 4;
      bMouseRight    = cButtonsPressed & 2;
   }
}

/*----------------------------------------------------------------------------*/

Boolean bMouseGetLeft()
{
   return bMouseLeft;
}

/*----------------------------------------------------------------------------*/

Boolean bMouseGetCenter()
{
   return bMouseCenter;
}

/*----------------------------------------------------------------------------*/

Boolean bMouseGetRight()
{
   return bMouseRight;
}

/*----------------------------------------------------------------------------*/

unsigned int uiMouseGetRow()
{
   return uiMouseRow;
}

/*----------------------------------------------------------------------------*/

unsigned int uiMouseGetCol()
{
   return uiMouseCol;
}

/*----------------------------------------------------------------------------*/

void MouseSetGrafPos( unsigned int uiNewRow, unsigned int uiNewCol )
{
   uiMouseGrafRow = uiNewRow;
   uiMouseGrafCol = uiNewCol;

   asm mov dx, uiNewRow;
   asm mov cx, uiNewCol;
   asm mov ax, 4;
   asm int 0x33;
}

/*----------------------------------------------------------------------------*/

void MouseSetPos( unsigned int uiNewRow, unsigned int uiNewCol )
{
   uiMouseRow = uiNewRow;
   uiMouseCol = uiNewCol;

   MouseSetGrafPos( uiNewRow * 8, uiNewCol * 8 );
}

/*----------------------------------------------------------------------------*/

unsigned int uiMouseGetGrafRow()
{
   return uiMouseGrafRow;
}

/*----------------------------------------------------------------------------*/

unsigned int uiMouseGetGrafCol()
{
   return uiMouseGrafCol;
}

/*----------------------------------------------------------------------------*/

void MouseSetArea( unsigned int uiTop, unsigned int uiLeft,
                   unsigned int uiDown, unsigned int uiRight )
{
   asm mov ax, 8;
   asm mov cx, uiTop;
   asm mov dx, uiDown;
   asm int 0x33;

   asm mov ax, 7;
   asm mov cx, uiLeft;
   asm mov dx, uiRight;
   asm int 0x33;
}

/*----------------------------------------------------------------------------*/

Boolean bMousePressed()
{
   return bMouseLeft || bMouseCenter || bMouseRight;
}

/*----------------------------------------------------------------------------*/
