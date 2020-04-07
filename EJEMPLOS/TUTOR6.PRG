// Compilar: CLIPPER tutor4.prg /n
// Enlazar:  RTlink fi tutor4 lib dialog

#include "dialog.ch"

#define ID_nFLDNAME    1
#define ID_nFLDTYPE    2
#define ID_nFLDLEN     3
#define ID_nADD        4
#define ID_nEDIT       5
#define ID_nDELETE     6
#define ID_nFIELDS     7
#define ID_nDBFNAME    8
#define ID_nCREATE     9
#define ID_nCANCEL    10

//----------------------------------------------------------------------------//

function Main()

   local dlgTest := DlgTest():New()

   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

   dlgTest:Exec()
   dlgTest:Hide()

return

//----------------------------------------------------------------------------//

CLASS DlgTest FROM Dialog

   VAR cbxFldType
   VAR edtFldName, edtFldLen, edtDbfName
   VAR pbtAdd, pbtEdit, pbtDelete, pbtCreate, pbtCancel
   VAR lbxFields

   METHOD New          = DtsNew
   METHOD EdtChanged   = DtsEdtChanged
   METHOD CtrlGotFocus = DtsCtrlGotFocus

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function DtsNew()

   ::Parent:New( 3, 15, 19, 65, "Creaci¢n de un fichero DBF" )

   ::edtFldName = Edit():New( 2, 3, 10, "", ID_nFLDNAME, "&Nombre",;
                              " Nombre del campo " )
   ::cbxFldType = ComboBox():New( 2, 16, 1, "C", ID_nFLDTYPE, "&Tipo",;
                                  " Seleccione el tipo adecuado " )
   ::edtFldLen  = Edit():New( 2, 21, 3, " 10", ID_nFLDLEN, "&Lon",;
                              " Longitud del campo " )
   ::edtDbfName = Edit():New( 14, 3, 20, "", ID_nDBFNAME, "Nombre del &DBF",;
                              " Nombre del DBF a crear " )
   ::pbtAdd     = PushButton():New(  2, 39, " &A¤adir ", ID_nADD, " A¤adir este campo " )
   ::pbtEdit    = PushButton():New(  5, 39, " &Editar ", ID_nEDIT, " Editar este campo " )
   ::pbtDelete  = PushButton():New(  7, 39, " &Borrar ", ID_nDELETE, " Borrar este campo " )
   ::pbtCreate  = PushButton():New( 14, 27, " C&rear  ", ID_nCREATE, " Crear el fichero DBF " )
   ::pbtCancel  = PushButton():New( 14, 37, " &Cancelar ", ID_nCANCEL, " Cancelar toda la operaci¢n " )
   ::lbxFields  = ListBox():New( 5, 3, 11, 35, "Ca&mpos", ID_nFIELDS, " Elija un campo " )

   ::pbtAdd:lActive    = .f.
   ::pbtEdit:lActive   = .f.
   ::pbtDelete:lActive = .f.
   ::cbxFldType:oListBox:acItems = { "C", "N", "L", "D", "M" }

   ::AddControl( ::edtFldName )
   ::AddControl( ::cbxFldType )
   ::AddControl( ::edtFldLen )
   ::AddControl( ::pbtAdd )
   ::AddControl( ::lbxFields )
   ::AddControl( ::pbtEdit )
   ::AddControl( ::pbtDelete )
   ::AddControl( ::edtDbfName )
   ::AddControl( ::pbtCreate )
   ::AddControl( ::pbtCancel )

return Self

//----------------------------------------------------------------------------//

METHOD function DtsEdtChanged( oEdit )

   local pbtDefault := ::pbtDefault()

   if oEdit:nId == ID_nFLDNAME
      if ! Empty( oEdit:cText )
         if pbtDefault != nil
            if pbtDefault:nId != ID_nADD
               pbtDefault:lDefault = .f.
               pbtDefault:Display()
               ::pbtAdd:lDefault = .t.
               ::pbtAdd:Display()
            else
               if ! ::pbtAdd:lDefault
                  ::pbtAdd:lDefault = .t.
                  ::pbtAdd:Display()
               endif
            endif
         else
            ::pbtAdd:lActive  = .t.
            ::pbtAdd:lDefault = .t.
            ::pbtAdd:Display()
         endif
      else
         if pbtDefault != nil
            if pbtDefault:nId == ID_nADD
               if ::pbtAdd:lDefault
                  ::pbtAdd:lDefault = .f.
                  ::pbtAdd:Display()
               endif
            endif
         endif
      endif
   endif

return

//----------------------------------------------------------------------------//

METHOD function DtsCtrlGotFocus( oControl )

   local pbtDefault := ::pbtDefault()

   do case
      case oControl:nId == ID_nFLDNAME
           if ! Empty( ::edtFldName:cText )
              ::pbtAdd:lDefault = .t.
              ::pbtAdd:Display()
           endif

      case oControl:nId == ID_nFLDTYPE
           if pbtDefault != nil
              if pbtDefault:nId == ID_nADD
                 ::pbtAdd:lDefault = .f.
                 ::pbtAdd:Display()
              endif
           endif
   endcase

return

//----------------------------------------------------------------------------//
