
#include "dialog.ch"

#define    nFIELDS     1
#define    nOPERS      2
#define    nSAMPLE     3
#define    nLINK       4      // .t. enlaza con .and. , .f. con .or.

#define    ID_nFIELDS    1
#define    ID_nOPERS     2
#define    ID_nSAMPLE    3
#define    ID_nLINK      4
#define    ID_nEXPLIST   5
#define    ID_nOK        6
#define    ID_nDELETE    7
#define    ID_nEXIT      8
#define    ID_nNEW       9
#define    ID_nSEARCH    10

STATIC acOper := { "Contiene a"       ,;
                   "Empieza por"      ,;
                   "Igual a"          ,;
                   "Mayor que"        ,;
                   "Mayor igual que"  ,;
                   "Menor que"        ,;
                   "Menor igual que"  ,;
                   "Diferente de"     }


FUNCTION BuildQuery()
LOCAL aCampos := { "Apellido 1§" , "Apellido 2§", "Nombre de Pila",;
                   "Calle / N§", "Poblaci¢n", "C¢d.Postal", "Provincia",;
                   "Tel‚fono" }

LOCAL oDlgQry := DlgQuery():New( aCampos )
   
   setcancel( .f. )

   SetColor( "W+/B" )
   CLS
   @ 23, 19 SAY "Dialog 1.00 (C) Antonio Linares Ca¤as, 1992" ;
     COLOR "GR+/B"

      oDlgQry:exec()
      oDlgQry:hide()

RETURN nil


  CLASS DlgQuery from Dialog

      VAR lNew
      VAR oQuery
      VAR cbxField, cbxOper
      VAR rbmLink
      VAR edtSample
      VAR lbxExpresion
      VAR pbtOk, pbtEdit, pbtDelete, pbtExit, pbtNew, pbtSearch


      METHOD New           = DlqNew
      METHOD CtrlLostFocus = DlqCtrlLostFocus
      METHOD CtrlGotFocus  = DlqCtrlGotFocus
      METHOD PbtClick      = DlqPbtClick
      METHOD LbxSelect     = DlqLbxSelect
      METHOD BlankEdts     = DlqBlankEdts

  ENDCLASS


  /***/
  METHOD function DlqNew( aCampos )

   ::Parent:New( 2, 4, 21, 75, "Constructor de Busquedas" )

   ::lNew := .t.     
   ::oQuery := Query():new( aCampos )
   
   ::cbxField = ComboBox():New( 3, 4, 19, "", ID_nFIELDS, "&Campo",;
                                " Seleccione campo donde buscar " )

   ::cbxOper  = ComboBox():New( 3, 28, 15, "", ID_nOPERS, "O&perador",;
                                " Seleccione operaci¢n " )

   ::edtSample :=  Edit():New( 3, 48, 20, "", ID_nSAMPLE,;
                    "&Muestra:", " Escriba valor para la operacion con el campo " )

   ::rbmLink      = RbMenu():New( 6, 48, "&Enlace", ID_nLINK,;
                    " Enlace entre esta expresion y la siguiente " )

   ::pbtoK      = PushButton():New(  9, 34, " &Ok ", ID_nOK, " Aceptar esta expresi¢n " )
   ::pbtDelete  = PushButton():New( 17, 11, " &Borrar ", ID_nDELETE, " Borrar expresi¢n de la Lista " )
   ::pbtExit    = PushButton():New( 17, 25, " &Salir ", ID_nEXIT, " Salir sin Buscar " )
   ::pbtNew     = PushButton():New( 17, 38, " &Nueva ", ID_nNEW, " Editar expresi¢n nueva " )
   ::pbtSearch  = PushButton():New( 17, 58, " &Buscar ", ID_nSEARCH, " Salir y buscar " )

   ::lbxExpresion = ListBox():New( 12, 4, 15, 68, "&Lista de expresiones",;
                                   ID_nEXPLIST, " Elija una expresi¢n " )

   ::edtSample:nMaxLen = 60

   ::cbxField:oListBox:acItems = aCampos
   ::cbxOper:oListBox:acItems = ::oQuery:GetaOp()
   ::rbmLink:AddItem( " &o < or >  " )
   ::rbmLink:AddItem( " &y < and > " )

   ::pbtOk:lActive     = .f.
   ::pbtOk:lDefault    = .f.
   ::pbtDelete:lActive = .f.

   ::AddControl( ::cbxField )
   ::AddControl( ::cbxOper )
   ::AddControl( ::edtSample )
   ::AddControl( ::rbmLink )
   ::AddControl( ::pbtOk )
   ::AddControl( ::lbxExpresion )
   ::AddControl( ::pbtDelete )
   ::AddControl( ::pbtExit )
   ::AddControl( ::pbtNew )
   ::AddControl( ::pbtSearch )

 RETURN Self

 /***/
 METHOD function DlqCtrlLostFocus( oControl )

   if oControl:nId == ID_nFIELDS ;
      .OR. oControl:nId == ID_nOPERS
   
      ::pbtOk:lDefault := .t.
            
      if ascan( oControl:oListBox:acItems, oControl:ctext ) == 0 ;
         .or. empty( oControl:cText )

         oControl:cText := oControl:oListBox:acItems[ max( oControl:oListBox:nOption,1) ]

      elseif Empty( ::cbxField:cText ) .or. ;
             Empty( ::cbxOper:cText )

         ::pbtOk:lActive := .f.
         ::pbtOk:Display()
      else
         ::pbtOk:lActive := .t.
         ::pbtOk:Display()
      
      endif
      
   endif

return nil

 /***/
 METHOD function DlqCtrlGotFocus( oControl )

   local pbtDefault := ::pbtDefault()

   if oControl:nId == ID_nFIELDS ;
      .OR. oControl:nId == ID_nOPERS

      ::pbtOk:lDefault := .f.
      
      if ascan( oControl:oListBox:acItems, oControl:ctext ) == 0 ;
         .or. empty( oControl:cText )
         
        // oControl:open()    // ­ Co¤o con el cursor ! :-(((
        // oControl:lbxSelect( oControl:oListBox ) // esto no hace n  :-((

        // bueno po esto... :-))
        oControl:cText := oControl:oListBox:acItems[ max( oControl:oListBox:nOption,1) ]

      endif
      
      if Empty( ::cbxField:cText ) .or. ;
             Empty( ::cbxOper:cText )
     
         ::pbtOk:lActive  = .f.
         ::pbtOk:Display()
      
      else
      
         ::pbtOk:lActive := .t.
         ::pbtOk:Display()

      endif
   
   elseif oControl:nId == ID_nSAMPLE .and. ::pbtOk:lActive
       ::pbtOk:lDefault := .t.

   elseif oControl:nId == ID_nEXPLIST

      ::lbxSelect( oControl )

   endif

return nil

 /***/
 METHOD function DlqPbtClick( oPbt )
 LOCAL aLbxExp

   aLbxExp := ::lbxExpresion:acItems

   if oPbt:nId == ID_nOK
      
      if ::lNew
         
         ::oQuery:add( ::cbxField:cText, ::cbxOper:cText,;
                       ::edtSample:cText, ( ::rbmLink:nOption == 2 ) )
       
      /* en vez de capturar aLbxExp deber¡a funcionar esto:
         ::lbxExpresion:addItem( aQry2cExp( ;
                                 ::oQuery:Get( ;
                                 len( ::lbxExpresion:acItems ) + 1 ) ) )
          pero va mal la scrollBar y el mettodo delete de ListBox,
          casca depues de borrar todos al intentar borrar otro.
       
      */
         
         aadd( aLbxExp, aQry2cExp( ::oQuery:Get( len( aLbxExp ) + 1 ) ) )
         ::lbxExpresion:setItems( aLbxExp )

         ::lNew := .f.
         ::lbxExpresion:goBottom()
         
         ::pbtDelete:lActive := .t.
         ::pbtDelete:display()
      else
         ::oQuery:set( ::lbxExpresion:nOption, ::cbxField:cText,;
                       ::cbxOper:cText, ::edtSample:cText,;
                       ( ::rbmLink:nOption == 2 ) )

         ::lbxExpresion:acItems[ ::lbxExpresion:nOption ] := ;
                                 aQry2cExp( ::oQuery:Get( ;
                                 ::lbxExpresion:nOption ) )
      endif
      // ::lbxExpresion:display()
      ::changeFocus( ::lbxExpresion )

   elseif oPbt:nId == ID_nDELETE

      if ::lNew
      
         ::blankEdts()
      
      elseif Len( aLbxExp ) > 0
      
         ::oQuery:del( ::lbxExpresion:nOption )
         adel( aLbxExp, ::lbxExpresion:nOption )
         asize( aLbxExp, len( aLbxExp ) - 1 )
         ::lbxExpresion:setItems( aLbxExp )
         // ::lbxExpresion:display()

         if Len( aLbxExp ) == 0
            ::BlankEdts()
            ::changeFocus( ::pbtNew )
         else
            ::changeFocus( ::lbxExpresion )
         endif
      
      endif

   elseif oPbt:nId == ID_nNEW
      
      if !::lNew
         ::lNew := .t.
      
         ::pbtDelete:lActive := .t.
         ::pbtDelete:display()
      
         ::BlankEdts()
         ::changeFocus( ::cbxField )
      endif

   else
      ::lEndExec = .t.
   endif

return nil

 /***/
 METHOD function DlqBlankEdts()

     ::cbxField:cText := ""
     ::cbxOper:cText  := ""
     ::rbmLink:setOption( 1 )
     ::edtSample:setText( "" )
     ::cbxField:display()
     ::cbxOper:display()
     ::rbmLink:display()

return nil

 /***/
 METHOD function DlqLbxSelect( oLbx )
 LOCAL aQry

   if oLbx:nId == ID_nEXPLIST

      aQry := ::oQuery:Get( oLbx:nOption )

      if oLbx:nOption > 0 .and. len( aQry ) > 0
         ::cbxField:cText := aQry[ nFIELDS ]
         ::cbxOper:cText  := aQry[ nOPERS ]
         ::rbmLink:setOption( iif( aQry[ nLINK ], 2, 1 ) )
         ::edtSample:setText( aQry[ nSAMPLE ] )
         ::cbxField:display()
         ::cbxOper:display()
         ::rbmLink:display()
      endif
   endif

return nil


/***/
STATIC Function aQry2cExp( aQry )
RETURN padr( rtrim( aQry[ nFIELDS ] ) + " "+ rtrim( aQry[ nOPERS ] ) + ;
                    " " + rtrim( aQry[ nSAMPLE ] ) , 60 ) + ;
                    if( aQry[ nLINK ], " y", " ¢" )

 CLASS QUERY

       VAR acFields
       VAR aQuerys

       METHOD New     =  QryNew
       METHOD Add     =  QryAdd
       METHOD Set     =  QrySet
       METHOD Del     =  QryDel
       METHOD Get     =  QryGet
       METHOD GetaOp  =  QryGetaOp

 ENDCLASS

 /***/
 METHOD function QryNew( aFields )

   ::acFields  := aFields
   ::aQuerys   := {}

 RETURN Self

 /***/
 METHOD function QryAdd( nField, nOper, cSample, lLink )
 RETURN  aadd( ::aQuerys, { nField, nOper, cSample, lLink } )

 /***/
 METHOD function QrySet( nWich, nField, nOper, cSample, lLink )
 LOCAL lRet := .F.

    if len( ::aQuerys ) > 0 .and. nWich > 0 .and. nWich <= len( ::aQuerys )

       ::aQuerys[ nWich ] := { nField, nOper, cSample, lLink }
       lRet := .T.

    endif

 RETURN lRet

 /***/
 METHOD function QryDel( nWich )
 LOCAL lRet := .F.

    if len( ::aQuerys ) > 0 .and. nWich > 0 .and. nWich <= len( ::aQuerys )

       aDel( ::aQuerys, nWich )
       asize( ::aQuerys, len( ::aQuerys ) - 1 )
       lRet := .T.

    endif

 RETURN lRet

 /***/
 METHOD function QryGet( nWich )
 LOCAL aRet := {}

    if len( ::aQuerys ) > 0 .and. nWich > 0 .and. nWich <= len( ::aQuerys )

       aRet := ::aQuerys[ nWich ]

    endif

 RETURN aRet

 /***/
 METHOD function QryGetaOp()
 RETURN acOper

