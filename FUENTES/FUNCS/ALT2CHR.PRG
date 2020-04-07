//----------------------------------------------------------------------------//

function cAlt2Chr( nKey )       // devuelve el chr correspondiente al c¢digo
                                // Alt pulsado desde Q a M
  do case
     case nKey >= 272 .and. nKey <= 281
          nKey = nKey - 271

     case nKey >= 286 .and. nKey <= 296
          nKey = nKey - 275

     case nKey >= 300 .and. nKey <= 306
          nKey = nKey - 279
  endcase

return SubStr( "QWERTYUIOPASDFGHJKL¥ZXCVBNM", nKey, 1  )

//----------------------------------------------------------------------------//
