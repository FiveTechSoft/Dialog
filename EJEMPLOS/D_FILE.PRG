#include "dialog.ch"

#define ID_nNAME   100
#define ID_nFILES  200
#define ID_nPATHS  300
#define ID_nOK     400
#define ID_nCANCEL 500

//----------------------------------------------------------------------------//

function Main()

   local dflTest1 := DlgFile():New( "Seleccione un Fichero", "*.*" )
   local dflTest2 := DlgFile():New( "Seleccione una DBF", "*.dbf" )

   SetCancel( .f. )
   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dflTest1:Exec()
   dflTest1:Hide()

   dflTest2:Exec()
   dflTest2:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgFile FROM Dialog

   VAR edtName
   VAR lbxFiles, lbxPaths
   VAR pbtOk, pbtCancel
   VAR cDrive, cPath, cMask

   METHOD New          = DflNew                // Constructor obligatorio!
   METHOD Init         = DflInit               // Redefinici¢n m‚todo d Dialog
   METHOD PbtClick     = DflPbtClick           // Redefinici¢n m‚todo d Dialog
   METHOD LbxSelect    = DflLbxSelect          // Redefinici¢n m‚todo d Dialog
   METHOD CtrlGotFocus = DflCtrlGotFocus       // Redefinici¢n m‚todo d Dialog
   METHOD LoadInfo     = DflLoadInfo           // M‚todo nuevo

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DflNew( cTitle, cMask )

   DEFAULT cTitle = "Seleccione un Fichero", cMask = "*.*"

   ::Parent:New( 4, 15, 19, 65, cTitle )

   ::edtName   = Edit():New( 2, 10, 22, "", ID_nNAME, "&Nombre",;
                             " Nombre y trayectoria del fichero" )
   ::lbxFiles  = ListBox():New( 7,  3, 14, 16, "&Ficheros", ID_nFILES,;
                                " Seleccione un fichero " )
   ::lbxPaths  = ListBox():New( 7, 20, 14, 33, "&Trayectoria", ID_nPATHS,;
                                " Seleccione Unidad ¢ Subdirectorio " )
   ::pbtOk     = PushButton():New( 2, 37, "    &Ok    ", ID_nOK,;
                                   " De Acuerdo " )
   ::pbtCancel = PushButton():New( 5, 37, "  &Cancel  ", ID_nCANCEL,;
                                   " Cancelar " )
   ::cDrive    = cDrive()
   ::cPath     = CurDir()
   ::cMask     = cMask

   ::edtName:oLabel:Move( 0, -7 )
   ::edtName:cText  = ::cMask
   ::pbtOk:lDefault = .t.

   ::AddControl( ::edtName )
   ::AddControl( ::lbxFiles )
   ::AddControl( ::lbxPaths )
   ::AddControl( ::pbtOk )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DflInit()

   local nRowOld := Row()
   local nColOld := Col()
   local nCrsOld := SetCursor( 0 )

   ::LoadInfo()
   ::Say( 4, 3, PadR( "Directorio: " + ::cDrive + ":\" + ::cPath, 40 ), "RB/W" )
   @ nRowOld, nColOld SAY ""
   SetCursor( nCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function DflPbtClick( Pbt )

   if Pbt:nId == ID_nOK
      do case
         case ::edtName:lFocused
              if ::edtName:cText != ::cMask
                 do case
                    case At( "\", ::edtName:cText ) != 0

                    case At( ":", ::edtName:cText ) != 0

                    case At( "*", ::edtName:cText ) != 0
                       ::cMask = ::edtName:cText
                       ::Init()

                    otherwise
                       ::EndExec()
                 endcase
              endif

         case ::lbxFiles:lFocused
              ::edtName:SetText( ::lbxFiles:acItems[ ::lbxFiles:nOption ] )
              ::EndExec()

         case ::lbxPaths:lFocused
              do case
                 case ::lbxPaths:acItems[ ::lbxPaths:nOption ] == ".."
                      ::edtName:SetText( ::cMask )
                      ::cPath = SubStr( ::cPath, 1, RAt( "\", ::cPath ) - 1 )
                      ::Init()
                      ::lbxPaths:Hilite()

                 case At( "[", ::lbxPaths:acItems[ ::lbxPaths:nOption ] ) != 0
                      ::edtName:SetText( ::cMask )
                      ::cDrive = SubStr( ::lbxPaths:acItems[ ::lbxPaths:nOption ], 3, 1 )
                      ::cPath  = CurDir( ::cDrive )
                      ::Init()
                      ::lbxPaths:Hilite()

                 otherwise
                      ::edtName:SetText( ::cMask )
                      ::cPath = ::cPath + If( ! Empty( ::cPath ), "\", "" ) + ;
                                + ::lbxPaths:acItems[ ::lbxPaths:nOption ]
                      ::Init()
                      ::lbxPaths:Hilite()
              endcase
      endcase
   else
      ::EndExec()
   endif

return

//----------------------------------------------------------------------------//

METHOD function DflLbxSelect( oListBox )

   local cItem := oListBox:acItems[ oListBox:nOption ]

   if oListBox:nId == ID_nPATHS
      if At( "[", cItem ) != 0
         ::edtName:SetText( SubStr( cItem, 3, 1 ) + ":" + ::cMask )
      else
         if cItem == ".."
            ::edtName:SetText( "..\" + ::cMask )
         else
            ::edtName:SetText( cItem + "\" + ::cMask )
         endif
      endif
   else
      ::edtName:SetText( cItem )
   endif

return

//----------------------------------------------------------------------------//

METHOD function DflCtrlGotFocus( oControl )

   if oControl:nId == ID_nCANCEL
      ::pbtOk:lDefault = .f.
      ::pbtOk:Display()
   else
      if ! ::pbtOk:lDefault
         ::pbtOk:lDefault = .t.
         ::pbtOk:Display()
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function DflLoadInfo()

   local acPaths := aDirectories( ::cDrive + ":\" + ::cPath + ;
                                  If( ! Empty( ::cPath ), "\", "" ) )

   AEval( aDrives(), { | cDrive | AAdd( acPaths, cDrive ) } )
   ::lbxFiles:SetItems( aFileNames( ::cDrive + ":\" + ::cPath + ;
                        If( ! Empty( ::cPath ), "\", "" ) + ::cMask ) )
   ::lbxPaths:SetItems( acPaths )

return

//----------------------------------------------------------------------------//
