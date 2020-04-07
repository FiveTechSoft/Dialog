#include "dialog.ch"

#define ID_nNOMBRE     100
#define ID_nSEXO       200
#define ID_nDIRECCION  300
#define ID_nPROVINCIA  400
#define ID_nHISTORIAL  500
#define ID_nPRODUCTOS  600
#define ID_nANTERIOR   700
#define ID_nSIGUIENTE  800
#define ID_nSALVAR     900
#define ID_nTERMINAR  1000

//----------------------------------------------------------------------------//

function Main()

   local ddbTest := DlgDb():New()

   SetColor( "W+/B" )
   CLS
   @ 23, 16 SAY "Dialog ver. 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   ddbTest:Exec()
   ddbTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgDb FROM Dialog

   VAR edtNombre, edtDireccion
   VAR cbxProvincia
   VAR pbtAnterior, pbtSiguiente, pbtSalvar, pbtTerminar
   VAR rbmSexo
   VAR cbmHistorial, cbmProductos

   METHOD New      = DdbNew
   METHOD Init     = DdbInit
   METHOD PbtClick = DdbPbtClick

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DdbNew()

   ::Parent:New( 2, 3, 19, 75, " Mantenimiento de Clientes " )

   ::edtNombre    = Edit():New( 3, 3, 30, "", ID_nNOMBRE,;
                    "&Nombre", " Escriba el Nombre y Apellidos del Cliente " )
   ::rbmSexo      = RbMenu():New( 3, 38, "&Sexo", ID_nSEXO,;
                    " Sexo del Cliente " )
   ::edtDireccion = Edit():New( 6, 3, 30, "", ID_nDIRECCION,;
                    "&Direcci¢n", " Escriba la Direcci¢n del Cliente " )
   ::cbxProvincia = ComboBox():New( 6, 53, 15, "", ID_nPROVINCIA,;
                    "&Provincia", " Seleccione una Provincia " )
   ::pbtAnterior  = PushButton():New( 15, 5, " &Anterior ",;
                    ID_nANTERIOR, " Cliente Anterior " )
   ::pbtSiguiente = PushButton():New( 15, 18, " S&iguiente ",;
                    ID_nSIGUIENTE, " Siguiente Cliente " )
   ::pbtSalvar    = PushButton():New( 15, 32, " Sal&var a Disco ",;
                    ID_nSALVAR, " Salvar a fichero " )
   ::pbtTerminar  = PushButton():New( 15, 52, " &Terminar ",;
                    ID_nTERMINAR, " Terminar y volver al DOS " )
   ::cbmHistorial = CbMenu():New( 9, 3, "&Historial",;
                    ID_nHISTORIAL,;
                    " Campa¤a comercial seguida con este Cliente " )
   ::cbmProductos = CbMenu():New( 9, 29, "P&roductos vendidos",;
                    ID_nPRODUCTOS,;
                    " Relaci¢n de productos suministrados " )

   ::rbmSexo:AddItem( "&Hombre " )
   ::rbmSexo:AddItem( "&Mujer  " )
   ::edtDireccion:nMaxLen = 50
   ::cbxProvincia:nMaxLen = 40
   ::cbxProvincia:oListBox:acItems = { " Alava ", " Teruel ", " M laga " }
   ::cbmHistorial:AddItem( "&Envio Cartas" )
   ::cbmHistorial:AddItem( "&Visitado" )
   ::cbmHistorial:AddItem( "&Telefoneado" )
   ::cbmHistorial:AddItem( "&Almuerzo negocios " )
   ::cbmProductos:AddItem( "&FivePro 1.00" )
   ::cbmProductos:AddItem( "F&astMenu 1.00 " )
   ::cbmProductos:AddItem( "&Mouse 1.00" )
   ::cbmProductos:AddItem( "&HelpEdit 1.1" )
   ::pbtSalvar:cClrNormal  = "N/R"
   ::pbtSalvar:cClrHotKey  = "GR+/R"
   ::pbtSalvar:cClrDefault = "BG+/R"

   ::AddControl( ::edtNombre )
   ::AddControl( ::rbmSexo )
   ::AddControl( ::edtDireccion )
   ::AddControl( ::cbxProvincia )
   ::AddControl( ::cbmHistorial )
   ::AddControl( ::cbmProductos )
   ::AddControl( ::pbtAnterior )
   ::AddControl( ::pbtSiguiente )
   ::AddControl( ::pbtSalvar )
   ::AddControl( ::pbtTerminar )

return Self

//----------------------------------------------------------------------------//

METHOD function DdbInit()

   USE Tutor9
   ::edtNombre:SetText( Tutor9->cNombre )
   ::rbmSexo:SetOption( If( Tutor9->cSexo == "V", 1, 2 ) )
   ::edtDireccion:SetText( Tutor9->cDireccion )

return

//----------------------------------------------------------------------------//

METHOD function DdbPbtClick( oPbt )

   do case
      case oPbt:nId == ID_nANTERIOR
           SKIP -1
           if BoF()
              GO TOP
           else
              ::edtNombre:SetText( Tutor9->cNombre )
              ::rbmSexo:SetOption( If( Tutor9->cSexo == "V", 1, 2 ) )
              ::edtDireccion:SetText( Tutor9->cDireccion )
              if RecNo() == 1
              endif
           endif

      case oPbt:nId == ID_nSIGUIENTE
           SKIP
           if EoF()
              GO BOTTOM
           else
              ::edtNombre:SetText( Tutor9->cNombre )
              ::rbmSexo:SetOption( If( Tutor9->cSexo == "V", 1, 2 ) )
              ::edtDireccion:SetText( Tutor9->cDireccion )
              if RecNo() == RecCount()
              endif
           endif
   endcase

return

//----------------------------------------------------------------------------//
