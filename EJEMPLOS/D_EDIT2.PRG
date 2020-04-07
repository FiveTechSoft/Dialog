/************************************************************************
 Fichero..: D_EDIT2.PRG
 Proyecto.: BETA DIALOG 
 Tema.....: EditPict
 Fecha....: 05-22-92 1:34am
 Versi¢n..: 1.00
 Notas....: Derivemos de edit...
 Autor....: Carlos Segura Sanz
************************************************************************/

#include "dialog.ch"

#define EDIT_nNUM    1
#define EDIT_nCHAR   2

//----------------------------------------------------------------------------//

function main()
   local a, n, c
   

   local ep1 := EditPict():New( 3, 2, "@E 9,999,999.99", EDIT_nNUM,;
                                "0", ;
                                1, ;
                                "&Valor 1", ;
                                "" )
                
   local ep2 := EditPict():New( 5, 2, "!!!!!!!!!!!!!!!xxxxxxxx", EDIT_nCHAR,;
                                "carlos", ;
                                1, ;
                                "&Cadena 1", ;
                                "" )

   setcolor( "w+/b" )
   cls
   @ 23,1 say padc( "EditPict - Test - Derivando de Edit()", 79 ) color "gr+/b"

   ep1:Exec()
   ep2:Exec()
    
return    



CLASS EditPict FROM Edit
   
   VAR cPicture
   VAR nType
   VAR cNoFormat
   
   METHOD New        = epNew
   METHOD BufDisplay = epBufDisplay
   METHOD KeyPressed = epKeyPressed

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function epNew( nF, nC, cPict, nType, cVal, cLabel, cText )
   local n

   n = iif( nType == EDIT_nNUM, len( transform( 0, cPict ) ), len( cPict ) )
   
   ::Parent:New( nF, nC, n, cVal, cLabel, cText )

   ::cNoFormat = cVal
   ::cPicture  = cPict
   ::nType     = nType

return Self

//----------------------------------------------------------------------------//

METHOD function epBufDisplay()

   ::cNoFormat = ::cText
   ::cText = transform( iif( ::nType == EDIT_nNUM, val( ::cNoFormat ), ;
                             ::cText ), ::cPicture ) 
   ::Parent:BufDisplay()
   ::cText = ::cNoFormat

return 

//----------------------------------------------------------------------------//

METHOD function epKeyPressed( nKey )
   
   local cNumKeys := "1234567890.,+-"

   if ::nType == EDIT_nNUM .and. ( at( chr( nKey ), cNumKeys ) # 0 .or. ;
                                                                   nKey < 33 )
      ::Parent:KeyPressed( nKey )
   elseif ::nType != EDIT_nNUM
          ::Parent:KeyPressed( nKey )
   endif

return
