//----------------------------------------------------------------------------//

function nMKeyWait( nTime, bAction )

   local nKeyCode := 0
   local nStart   := Seconds()
   local nMRowOld := nMRow()
   local nMColOld := nMCol()

   nTime = If( nTime == nil, 0, nTime )

   MUpdate()
   do while ( nKeyCode := InKey() ) == 0 .and. ;
            ! lMPressed()                .and. ;
            If( nTime == 0, .t., Seconds() - nStart < nTime )

      MUpdate()
      if nMRow() != nMRowOld .or. nMCol() != nMColOld
         SetMCursor( 1 )
      endif
      if bAction != nil
         Eval( bAction )
      endif
   enddo

   SetMCursor( If( nKeyCode == 0, 1, 0 ) )

   if SetKey( nKeyCode ) != nil
      Eval( SetKey( nKeyCode ) )
   endif

return nKeyCode

//----------------------------------------------------------------------------//
