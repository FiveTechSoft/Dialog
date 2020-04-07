/************************************************************************
 Fichero..: D_TEST.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: DlgTest
 Fecha....: 05-21-92 08:38pm
 Versi¢n..: 1.00
 Notas....: ¨ Mensajes y Objetos ?, es OOP
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define ID_nPBT1     1
#define ID_nPBT2     2
#define ID_nCBM      3
#define ID_nRBM      4
#define ID_nSBR      5
#define ID_nLBX      6
#define ID_nEDT      7
#define ID_nCBT      8
#define ID_nRBT      9
#define ID_nCBX      10 
#define ID_nLBXCTRL  11

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTest():New()

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "DlgTest - Test", 79 ) color "gr+/b"

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR pbt1
   VAR pbt2
   VAR cbm
   VAR rbm
   VAR sbr
   VAR lbx
   VAR edt
   VAR cbt
   VAR rbt
   VAR cbx
   VAR lbxCtrl
   VAR aCtrls
                        
   METHOD New           = DxNew
   METHOD Init          = DxInit
   METHOD PbtClick      = DxPbtClick   
   METHOD LbxSelect     = DxLbxSelect
   METHOD LbxChanged    = DxLbxChanged
   METHOD LbxChoosed    = DxLbxChoosed
   METHOD EdtSelect     = DxEdtSelect
   METHOD EdtChanged    = DxEdtChanged
   METHOD CbtChanged    = DxCbtChanged
   METHOD RbtChanged    = DxRbtChanged
   METHOD MnuSelect     = DxMnuSelect
   METHOD MnuChanged    = DxMnuChanged
   METHOD CbmChanged    = DxCbmChanged
   METHOD SbrUp         = DxSbrUp
   METHOD SbrDown       = DxSbrDown
   METHOD SbrPgUp       = DxSbrPgUp
   METHOD SbrPgDown     = DxSbrPgDown
   METHOD CbxSelect     = DxCbxSelect
   METHOD CbxChanged    = DxCbxChanged
   METHOD CtrlGotFocus  = DxCtrlGotFocus
   METHOD CtrlLostFocus = DxCtrlLostFocus
   METHOD KeyPressed    = DxKeyPressed
   METHOD Click         = DxClick
   METHOD DblClick      = DxDblClick
ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DxNew()
   
   ::Parent:New( 1, 1, 22, 78, "¨ A donde van los mensajes ?" )

   ::Pbt1   = PushButton():New( 2, 2, ;
                                " &PushButton1 ", ;
                                ID_nPBT1, ;
                                " Hola, soy PushButton 1" ) 

   ::Pbt2   = PushButton():New( 5, 2, ;
                                " Push&Button2 ", ;
                                ID_nPBT2, ;
                                " Hola, soy PushButton 2" ) 

   ::cbm    = CbMenu():New( 3, 18, ;
                            " &CbMenu ", ;
                            ID_nCBM, ;
                            " Yo soy, CbMenu" )

   ::rbm    = RbMenu():New( 3, 34, ;
                            " &RbMenu ", ;
                            ID_nRBM, ;
                            " Y yo RbMenu" )

   ::sbr    = ScrollBar():New( 9, 2, 20 , ;
                              "&ScrollBar", ;
                              ID_nSBR, ;
                              " ­Mueveme!, soy ScrollBar", ;
                              .t. )  

   ::lbx    = ListBox():New( 3, 54, 6, 76, ;
                             "&ListBox", ;
                             ID_nLBX, ;
                             " Nadie como ListBox" )
 
   ::edt    = Edit():New( 7, 19, 20, ;
                         "", ;
                         ID_nEDT, ;
                         "&Edit", ;
                         " Edit, ­autentico!" ) 

   ::cbt    = CheckBtn():New( 9, 30, ;
                              "C&heckButton", ;
                              ID_nCBT, ;
                              " Pueque¤o pero mat¢n" )

   ::rbt    = RadioBtn():New( 11, 30, ;
                              "&RadioButton", ;
                              ID_nRBT, ;
                              " Soy RadioButton, hermano de CheckButton" )

   ::cbx    = ComboBox():New( 9, 54, 11, ;
                              "", ;
                              ID_nCBX, ;
                              "C&omboBox", ;
                              "Soy un hibrido entre Edit y Listbox" )
   
   ::lbxCtrl= ListBox():New( 14, 3, 20, 77, ;
                             "Sucesos", ;
                             ID_nLBXCTRL, ;
                             "" )

   ::cbm:AddItem( "Chk Item 1" )
   ::cbm:AddItem( "Chk Item 2" )

   ::rbm:AddItem( "Radio Item 1" )
   ::rbm:AddItem( "Radio Item 2" )

   ::lbx:AddItem( "ListBox Item 1" )
   ::lbx:AddItem( "ListBox Item 2" )
   ::lbx:AddItem( "ListBox Item 3" )

   /*
   ::cbx:oListBox:AddItem( "Cbx Item 1" )
   ::cbx:oListBox:AddItem( "Cbx Item 2" )
   ::cbx:oListBox:AddItem( "Cbx Item 3" )
   ::cbx:oListBox:AddItem( "Cbx Item 4" )
   */
   
   ::cbx:nMaxLen = 15

   
   ::lbxCtrl:lActive = .f. 

   ::aCtrls = { "PushButton1",     ;
                "PushButton2",     ;
                "CheckBoxMenu",    ; 
                "RadioButtonMenu", ;
                "ScrollBar",       ;
                "ListBox",         ;
                "Edit",            ;
                "CheckButton",     ;
                "RadioButton",     ;
                "ComboBox"         }  

   ::AddControl( ::pbt1 )
   ::AddControl( ::pbt2 )
   ::AddControl( ::cbm  )
   ::AddControl( ::rbm  )
   ::AddControl( ::sbr  )
   ::AddControl( ::lbx  )
   ::AddControl( ::edt  )
   ::AddControl( ::cbt  )
   ::AddControl( ::rbt  )
   ::AddControl( ::cbx  )

return Self

//----------------------------------------------------------------------------//

METHOD function DxInit()
   SaySuccess( Self, "Init" )
return 

//----------------------------------------------------------------------------//

METHOD function DxPbtClick( oPbt )   
   SaySuccess( Self, "PbtClick" )
return

//----------------------------------------------------------------------------//

METHOD function DxLbxSelect( oLbx )        
   SaySuccess( Self, "LbxSelect" )
return

//----------------------------------------------------------------------------//

METHOD function DxLbxChanged( oLbx )       
   SaySuccess( Self, "LbxChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxLbxChoosed( oLbx )
   SaySuccess( Self, "LbxChoossed" )
return

//----------------------------------------------------------------------------//

METHOD function DxEdtSelect( oEdt )
   SaySuccess( Self, "EdtSelect" )
return

//----------------------------------------------------------------------------//

METHOD function DxEdtChanged( oEdt )
   SaySuccess( Self, "EdtChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxCbtChanged( oCbt )
   SaySuccess( Self, "CbtChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxRbtChanged( oRbt )
   SaySuccess( Self, "RbtChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxMnuSelect( oMnu )
   SaySuccess( Self, "MnuSelect" )
return

//----------------------------------------------------------------------------//

METHOD function DxMnuChanged( oMnu )
   SaySuccess( Self, "MnuChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxCbmChanged( oCbm )
   SaySuccess( Self, "CbmChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxSbrUp( oSbr )
   SaySuccess( Self, "SbrUp" )
return

//----------------------------------------------------------------------------//

METHOD function DxSbrDown( oSbr )
   SaySuccess( Self, "SbrDown" )
return

//----------------------------------------------------------------------------//

METHOD function DxSbrPgUp( oSbr )
   SaySuccess( Self, "SbrPgUp" )
return

//----------------------------------------------------------------------------//

METHOD function DxSbrPgDown( oSbr )
   SaySuccess( Self, "SbrPgDown" )
return

//----------------------------------------------------------------------------//

METHOD function DxCbxSelect( oEdt )
   SaySuccess( Self, "CbxSelect" )
return

//----------------------------------------------------------------------------//

METHOD function DxCbxChanged( oEdt )
   SaySuccess( Self, "CbxChanged" )
return

//----------------------------------------------------------------------------//

METHOD function DxCtrlGotFocus( oCtrl )
   SaySuccess( Self, "CtrlGotFocus" )
return

//----------------------------------------------------------------------------//

METHOD function DxCtrlLostFocus( oCtrl )
   SaySuccess( Self, "CtrlLostFocus" )
return

//----------------------------------------------------------------------------//

METHOD function DxKeyPressed( nKey )
   SaySuccess( Self, "KeyPressed" )
   ::Parent:KeyPressed( nKey )
return 

//----------------------------------------------------------------------------//

METHOD function DxClick( nX, nY )
   SaySuccess( Self, "Click" )
   ::Parent:Click( nX, nY )
return 

//----------------------------------------------------------------------------//

METHOD function DxDblClick( nX, nY )
   SaySuccess( Self, "DblClick" )
   ::Parent:DblClick( nX, nY )
return 

//----------------------------------------------------------------------------//

static function SaySuccess( o, cMsg )

   local cObj := o:aCtrls[ o:nControl ]
   
   o:LbxCtrl:lActive = .t.
   o:lbxCtrl:AddItem( padr( "MENSAJE :" + cMsg, 25) + ;
                      padr( "Ctrl Activo :" + cObj, 25 ) )
   o:lbxCtrl:Display()
   o:LbxCtrl:GoBottom()
   o:LbxCtrl:lActive = .f.

return 

//---------------------------------------------------------------------------//
