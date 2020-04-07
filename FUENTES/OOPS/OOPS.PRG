#include "oops.ch"

static nHandle, aClassMakers := {}

//----------------------------------------------------------------------------//

function ClassMaker()

   if nHandle == nil

      nHandle = __ClassNew( "CLASSMAKER", 4 )

      __ClassAdd( nHandle, "_nHandle",  "_1" )       // Set
      __ClassAdd( nHandle, "nHandle",   "_1" )       // Get
      __ClassAdd( nHandle, "_cName",    "_2" )
      __ClassAdd( nHandle, "cName",     "_2" )
      __ClassAdd( nHandle, "_aVars",    "_3" )
      __ClassAdd( nHandle, "aVars",     "_3" )
      __ClassAdd( nHandle, "_aMethods", "_4" )
      __ClassAdd( nHandle, "aMethods",  "_4" )

      __ClassAdd( nHandle, "New", "CmkNew" )
      __ClassAdd( nHandle, "AddVar", "CmkAddVar" )
      __ClassAdd( nHandle, "AddMethod", "CmkAddMethod" )
      __ClassAdd( nHandle, "Make", "CmkMake" )
      __ClassAdd( nHandle, "oInstance", "oCmkInstance" )

   endif

return __ClassIns( nHandle )

//----------------------------------------------------------------------------//

METHOD function CmkNew( cName, bParent )

   local cParentName, cmkParent

   ::cName = Upper( cName )
   if bParent != nil
      cmkParent  = aClassMakers[ Eval( bParent ):ClassH() ]
      ::aVars    = AClone( cmkParent:aVars )
      ::aMethods = AClone( cmkParent:aMethods )
   else
      ::aVars     = {}
      ::aMethods  = {}
   endif

return Self

//----------------------------------------------------------------------------//

METHOD function CmkAddVar( cVarName )

   local bNameComp := { | cVar | cVar == cVarName }

   if AScan( ::aVars, bNameComp ) == 0
      AAdd( ::aVars, cVarName )
   endif

return

//----------------------------------------------------------------------------//

METHOD function CmkAddMethod( cMethodName, cUdfName )

   local nAt

   cMethodName = Upper( cMethodName )
   DEFAULT cUdfName = cMethodName

   nAt = AScan( ::aMethods, { | aMethod | aMethod[ 1 ] == cMethodName } )
   if nAt == 0
      AAdd( ::aMethods, { cMethodName, { cUdfName }, 1 } )
   else
      AAdd( ::aMethods[ nAt ][ 2 ], cUdfName )
      ::aMethods[ nAt ][ 3 ]++
   endif

return

//----------------------------------------------------------------------------//

METHOD function CmkMake()

   ::nHandle = __ClassNew( ::cName, Len( ::aVars ) )
   ASize( aClassMakers, ::nHandle )
   aClassMakers[ Len( aClassMakers ) ] = Self

   AEval( ::aVars,;
   { | cVarName, n | ;
   __ClassAdd( ::nHandle, cVarName, "_" + Str( n, If( n < 10, 1, 2 ) ) ),;
   __ClassAdd( ::nHandle, "_" + cVarName, "_" + Str( n, If( n < 10, 1, 2 ) ) ) } )

   AEval( ::aMethods,;
   { | aMethod | ;
   __ClassAdd( ::nHandle, aMethod[ 1 ], ATail( aMethod[ 2 ] ) ) } )

return

//----------------------------------------------------------------------------//

METHOD function oCmkInstance()

return __ClassIns( ::nHandle )

//----------------------------------------------------------------------------//

METHOD function ClsParent( cMethodName, xParam1, xParam2, xParam3, xParam4,;
                       xParam5, xParam6, xParam7, xParam8, xParam9, xParam10 )

   local Class        := aClassMakers[ ::ClassH() ]
   local bMethodComp  := { | aMethod | aMethod[ 1 ] == cMethodName }
   local nWichMethod  := AScan( Class:aMethods, bMethodComp )
   local aThisMethod  := Class:aMethods[ nWichMethod ]
   local xReturnVal

   __ClassAdd( Class[ 1 ], "__xParent",;
               aThisMethod[ 2 ][ --aThisMethod[ 3 ] ] )

   xReturnVal = ::__xParent( xParam1, xParam2, xParam3, xParam4,;
                xParam5, xParam6, xParam7, xParam8, xParam9, xParam10 )

   __ClassAdd( Class[ 1 ], "__xParent", nil )
   aThisMethod[ 3 ]++

return xReturnVal

//----------------------------------------------------------------------------//

function _1( xParam )
return If( PCount() > 0, QSelf()[ 1 ] := xParam, QSelf()[ 1 ] )

function _2( xParam )
return If( PCount() > 0, QSelf()[ 2 ] := xParam, QSelf()[ 2 ] )

function _3( xParam )
return If( PCount() > 0, QSelf()[ 3 ] := xParam, QSelf()[ 3 ] )

function _4( xParam )
return If( PCount() > 0, QSelf()[ 4 ] := xParam, QSelf()[ 4 ] )

function _5( xParam )
return If( PCount() > 0, QSelf()[ 5 ] := xParam, QSelf()[ 5 ] )

function _6( xParam )
return If( PCount() > 0, QSelf()[ 6 ] := xParam, QSelf()[ 6 ] )

function _7( xParam )
return If( PCount() > 0, QSelf()[ 7 ] := xParam, QSelf()[ 7 ] )

function _8( xParam )
return If( PCount() > 0, QSelf()[ 8 ] := xParam, QSelf()[ 8 ] )

function _9( xParam )
return If( PCount() > 0, QSelf()[ 9 ] := xParam, QSelf()[ 9 ] )

function _10( xParam )
return If( PCount() > 0, QSelf()[ 10 ] := xParam, QSelf()[ 10 ] )

function _11( xParam )
return If( PCount() > 0, QSelf()[ 11 ] := xParam, QSelf()[ 11 ] )

function _12( xParam )
return If( PCount() > 0, QSelf()[ 12 ] := xParam, QSelf()[ 12 ] )

function _13( xParam )
return If( PCount() > 0, QSelf()[ 13 ] := xParam, QSelf()[ 13 ] )

function _14( xParam )
return If( PCount() > 0, QSelf()[ 14 ] := xParam, QSelf()[ 14 ] )

function _15( xParam )
return If( PCount() > 0, QSelf()[ 15 ] := xParam, QSelf()[ 15 ] )

function _16( xParam )
return If( PCount() > 0, QSelf()[ 16 ] := xParam, QSelf()[ 16 ] )

function _17( xParam )
return If( PCount() > 0, QSelf()[ 17 ] := xParam, QSelf()[ 17 ] )

function _18( xParam )
return If( PCount() > 0, QSelf()[ 18 ] := xParam, QSelf()[ 18 ] )

function _19( xParam )
return If( PCount() > 0, QSelf()[ 19 ] := xParam, QSelf()[ 19 ] )

function _20( xParam )
return If( PCount() > 0, QSelf()[ 20 ] := xParam, QSelf()[ 20 ] )

function _21( xParam )
return If( PCount() > 0, QSelf()[ 21 ] := xParam, QSelf()[ 21 ] )

function _22( xParam )
return If( PCount() > 0, QSelf()[ 22 ] := xParam, QSelf()[ 22 ] )

function _23( xParam )
return If( PCount() > 0, QSelf()[ 23 ] := xParam, QSelf()[ 23 ] )

function _24( xParam )
return If( PCount() > 0, QSelf()[ 24 ] := xParam, QSelf()[ 24 ] )

function _25( xParam )
return If( PCount() > 0, QSelf()[ 25 ] := xParam, QSelf()[ 25 ] )

function _26( xParam )
return If( PCount() > 0, QSelf()[ 26 ] := xParam, QSelf()[ 26 ] )

function _27( xParam )
return If( PCount() > 0, QSelf()[ 27 ] := xParam, QSelf()[ 27 ] )

function _28( xParam )
return If( PCount() > 0, QSelf()[ 28 ] := xParam, QSelf()[ 28 ] )

function _29( xParam )
return If( PCount() > 0, QSelf()[ 29 ] := xParam, QSelf()[ 29 ] )

function _30( xParam )
return If( PCount() > 0, QSelf()[ 30 ] := xParam, QSelf()[ 30 ] )

function _31( xParam )
return If( PCount() > 0, QSelf()[ 31 ] := xParam, QSelf()[ 31 ] )

function _32( xParam )
return If( PCount() > 0, QSelf()[ 32 ] := xParam, QSelf()[ 32 ] )

function _33( xParam )
return If( PCount() > 0, QSelf()[ 33 ] := xParam, QSelf()[ 33 ] )

function _34( xParam )
return If( PCount() > 0, QSelf()[ 34 ] := xParam, QSelf()[ 34 ] )

function _35( xParam )
return If( PCount() > 0, QSelf()[ 35 ] := xParam, QSelf()[ 35 ] )

function _36( xParam )
return If( PCount() > 0, QSelf()[ 36 ] := xParam, QSelf()[ 36 ] )

function _37( xParam )
return If( PCount() > 0, QSelf()[ 37 ] := xParam, QSelf()[ 37 ] )

function _38( xParam )
return If( PCount() > 0, QSelf()[ 38 ] := xParam, QSelf()[ 38 ] )

function _39( xParam )
return If( PCount() > 0, QSelf()[ 39 ] := xParam, QSelf()[ 39 ] )

function _40( xParam )
return If( PCount() > 0, QSelf()[ 40 ] := xParam, QSelf()[ 40 ] )

function _41( xParam )
return If( PCount() > 0, QSelf()[ 41 ] := xParam, QSelf()[ 41 ] )

function _42( xParam )
return If( PCount() > 0, QSelf()[ 42 ] := xParam, QSelf()[ 42 ] )

function _43( xParam )
return If( PCount() > 0, QSelf()[ 43 ] := xParam, QSelf()[ 43 ] )

function _44( xParam )
return If( PCount() > 0, QSelf()[ 44 ] := xParam, QSelf()[ 44 ] )

function _45( xParam )
return If( PCount() > 0, QSelf()[ 45 ] := xParam, QSelf()[ 45 ] )

function _46( xParam )
return If( PCount() > 0, QSelf()[ 46 ] := xParam, QSelf()[ 46 ] )

function _47( xParam )
return If( PCount() > 0, QSelf()[ 47 ] := xParam, QSelf()[ 47 ] )

function _48( xParam )
return If( PCount() > 0, QSelf()[ 48 ] := xParam, QSelf()[ 48 ] )

function _49( xParam )
return If( PCount() > 0, QSelf()[ 49 ] := xParam, QSelf()[ 49 ] )

function _50( xParam )
return If( PCount() > 0, QSelf()[ 50 ] := xParam, QSelf()[ 50 ] )

//----------------------------------------------------------------------------//
