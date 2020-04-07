//----------------------------------------------------------------------------//

function aDrives()

   local nLogicDrives := nLogDrives()
   local aDrives := {}
   local n

   for n = 1 to nLogicDrives
       AAdd( aDrives, "[-" + Chr( 64 + n ) + "-]" )
   next

return aDrives

//----------------------------------------------------------------------------//
