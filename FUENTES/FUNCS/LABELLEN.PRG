function nLabelLen( cLabel )             // With embedes '&'

return Len( cLabel ) - If( At( "&", cLabel ) != 0, 1, 0 )
