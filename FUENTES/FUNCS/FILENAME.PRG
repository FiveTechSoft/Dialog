#include "dialog.ch"
#include "directry.ch"

/*----------------------------------------------------------------------------*/

function aFileNames( cDirSpec )

   local aFileNames := {}

   DEFAULT cDirSpec = "*.*"

   AEval( Directory( cDirSpec ), ;
          { | aFileInfo | AAdd( aFileNames, aFileInfo[ F_NAME ] ) } )

return ASort( aFileNames )

/*----------------------------------------------------------------------------*/
