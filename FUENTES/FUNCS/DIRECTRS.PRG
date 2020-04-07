#include "dialog.ch"
#include "directry.ch"

//----------------------------------------------------------------------------//

function aDirectories( cPath )

   local aDir
   local aDirectories := {}
   local n
   local nLen

   DEFAULT cPath = ""

   aDir = Directory( cPath + "*.*", "D" )
   nLen = Len( aDir )

   for n = 1 to nLen
       if aDir[ n ][ F_ATTR ] == "D" .and. ! aDir[ n ][ F_NAME ] == "."
          AAdd( aDirectories, aDir[ n ][ F_NAME ] )
       endif
   next

return ASort( aDirectories )

//----------------------------------------------------------------------------//
