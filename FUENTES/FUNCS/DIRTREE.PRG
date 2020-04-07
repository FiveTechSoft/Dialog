#include "dialog.ch"

static aDirTree

//----------------------------------------------------------------------------//

function aDirTree( cPath, cLine )

   local aDirectories := Directory( If( cPath == nil, cPath := "", cPath ) + ;
                                    "*.*", "D" )
   local nDirs := 0, nLastDir := 0, n

   DEFAULT cLine = ""

   if ProcName( 1 ) != "ADIRTREE"
      aDirTree = { { cPath }, { " \ " } }
   endif

   for n = 1 to Len( aDirectories )
       if aDirectories[ n ][ 5 ] == "D" .and. ;
          aDirectories[ n ][ 1 ] != "." .and. ;
          aDirectories[ n ][ 1 ] != ".."
          nDirs++
       endif
   next

   for n = 1 to Len( aDirectories )
       if aDirectories[ n ][ 5 ] == "D" .and. ;
          aDirectories[ n ][ 1 ] != "." .and. ;
          aDirectories[ n ][ 1 ] != ".."
          nLastDir++
          AAdd( aDirTree[ 1 ], cPath + aDirectories[ n ][ 1 ] )
          AAdd( aDirTree[ 2 ], cLine + ;
                If( nLastDir != nDirs, " ÃÄ ", " ÀÄ " ) + ;
                aDirectories[ n ][ 1 ] )
          aDirTree( cPath + aDirectories[ n ][ 1 ] + "\",;
                    cLine + If( nLastDir != nDirs, " ³ ", "   " ) )
       endif
   next

return aDirTree

//----------------------------------------------------------------------------//
