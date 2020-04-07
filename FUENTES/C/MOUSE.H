#ifndef _MOUSE_H
#define _MOUSE_H

#ifndef BOOLEAN
#define BOOLEAN
typedef enum{  False, True } Boolean;
#endif

void    MouseInit();
Boolean bIsMouse();
void    MouseSetCursor( Boolean bOnOff );
char    cMouseGetButtons();
Boolean bMouseGetCursor();
void    MouseUpdate();
Boolean bMouseGetLeft();
Boolean bMouseGetCenter();
Boolean bMouseGetRight();
unsigned int uiMouseGetRow();
unsigned int uiMouseGetCol();
void    MouseSetGrafPos( unsigned int uiNewRow, unsigned int uiNewCol );
void    MouseSetPos( unsigned int uiNewRow, unsigned int uiNewCol );
unsigned int uiMouseGetGrafRow();
unsigned int uiMouseGetGrafCol();
void    MouseSetArea( unsigned int uiTop, unsigned int uiLeft,
                      unsigned int uiDown, unsigned int uiRight );
Boolean bMousePressed();

#endif
