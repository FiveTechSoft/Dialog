#include "dialog.ch"

#define ID_nDIRS   100
#define ID_nCHANGE 200
#define ID_nREAD   300
#define ID_nEND    400
#define ID_nTREE   500
#define ID_nPREV   600
#define ID_nNEXT   700

//----------------------------------------------------------------------------//

function Main()

   local ddrTest := DlgDirs():New()

   AltD( 0 )                            // Desactiva las llamadas al Debugger
   SetCancel( .f. )                     // Para poder usar Alt-C
   SetColor( "W+/B" )
   CLS
   @ 23, 18 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   ddrTest:Exec()
   ddrTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgDirs FROM Dialog

   VAR lbxDirs
   VAR pbtChange, pbtRead, pbtEnd, pbtPrev, pbtNext
   VAR aTrees
   VAR cDrive
   VAR cbtTree

   METHOD New        = DdrNew              // Constructor ­es obligatorio!
   METHOD Init       = DdrInit             // Redefinici¢n de Dialog
   METHOD PbtClick   = DdrPbtClick         // Redefinici¢n de Dialog
   METHOD CbtChanged = DdrCbtChanged       // Redefinici¢n de Dialog
   METHOD Change     = DdrChange           // M‚todo nuevo
   METHOD Read       = DdrRead             // M‚todo nuevo

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DdrNew()

   ::Parent:New( 3, 15, 19, 62, " Seleccione un Directorio " )

   ::lbxDirs   = ListBox():New(  3, 3, 14, 31, "&Directorios", ID_nDIRS,;
                                " Listado de Directorios " )
   ::pbtChange = PushButton():New(  3, 34, " &Cambiar  ", ID_nCHANGE,;
                                   " Cambiar a ese Directorio " )
   ::pbtRead   = PushButton():New(  5, 34, " Re&leer   ", ID_nREAD,;
                                   " ReLeer Unidad " )
   ::pbtEnd    = PushButton():New(  7, 34, " &Terminar ", ID_nEND,;
                                   " Terminar la ejecuci¢n " )
   ::pbtPrev   = PushButton():New( 13, 34, " << ", ID_nPREV,;
                                   " Unidad Anterior " )
   ::pbtNext   = PushButton():New( 13, 40, " >> ", ID_nNEXT,;
                                   " Unidad Siguiente " )
   ::aTrees    = Array( nLogDrives() )
   ::cDrive    = cDrive()
   ::cbtTree   = CheckBtn():New( 10, 34, "&Arbol", ID_nTREE,;
                                 " Visualizar Arbol " )

   ::AddControl( ::lbxDirs )
   ::AddControl( ::pbtChange )
   ::AddControl( ::pbtRead )
   ::AddControl( ::pbtEnd )
   ::AddControl( ::cbtTree )
   ::AddControl( ::pbtPrev )
   ::AddControl( ::pbtNext )

return Self

//----------------------------------------------------------------------------//

METHOD function DdrInit()

   ::Say( 12, 34, "Unidad " + ::cDrive + ":\" )
   ::Read()

return

//----------------------------------------------------------------------------//

METHOD function DdrPbtClick( oPushButton )

   do case
      case oPushButton:nId == ID_nCHANGE
           if ::lbxDirs:nOption != 0
              if ::cDrive != cDrive()
                 DrvSelect( Asc( ::cDrive ) - 65 )
              endif
              lChDir( ::aTrees[ Asc( ::cDrive ) - 64 ][ 1 ];
                      [ ::lbxDirs:nOption ] )
              ::EndExec()
           endif

      case oPushButton:nId == ID_nREAD
           ::Read()

      case oPushButton:nId == ID_nEND
           ::EndExec()

      case oPushButton:nId == ID_nPREV
           if Asc( ::cDrive ) - 64 > 1
              ::cDrive = Chr( Asc( ::cDrive ) - 1 )
              ::Say( 12, 34, "Unidad " + ::cDrive + ":\" )
              ::Change()
           else
              Tone( 900, 0.5 )
           endif

      case oPushButton:nId == ID_nNEXT
           if Asc( ::cDrive ) - 64 < nLogDrives()
              ::cDrive = Chr( Asc( ::cDrive ) + 1 )
              ::Say( 12, 34, "Unidad " + ::cDrive + ":\" )
              ::Change()
           else
              Tone( 900, 0.5 )
           endif
   endcase

return

//----------------------------------------------------------------------------//

METHOD function DdrCbtChanged()

   ::Change()

return

//----------------------------------------------------------------------------//

METHOD function DdrChange()

   if ::aTrees[ Asc( ::cDrive ) - 64 ] != nil
      ::lbxDirs:SetItems( ::aTrees[ Asc( ::cDrive ) - 64 ];
                          [ If( ::cbtTree:lChecked, 2, 1 ) ] )
   else
      ::Read()
   endif

return

//----------------------------------------------------------------------------//

METHOD function DdrRead()

   ::Say( 15, 17, "* Aguarde *", "RB*/W" )
   ::aTrees[ Asc( ::cDrive ) - 64 ] = AClone( aDirTree( ::cDrive + ":\" ) )
   ::lbxDirs:SetItems( ::aTrees[ Asc( ::cDrive ) - 64 ];
                       [ If( ::cbtTree:lChecked, 2, 1 ) ] )
   ::Say( 15, 17, "           " )

return

//----------------------------------------------------------------------------//
