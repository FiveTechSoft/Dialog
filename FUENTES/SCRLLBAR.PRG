#include "dialog.ch"
#include "inkey.ch"

//----------------------------------------------------------------------------//

CLASS ScrollBar FROM Visual

   VAR cString
   VAR cClrArrows, cClrBar, cClrThumb
   VAR nLen, nRange, nValue, nThumbPos
   VAR lHorizontal
   VAR oLabel

   METHOD New        = SbrNew
   METHOD Display    = SbrDisplay
   METHOD Hide       = SbrHide
   METHOD ThmCheck   = SbrThmCheck
   METHOD KeyPressed = SbrKeyPressed
   METHOD Click      = SbrClick
   METHOD GoTop      = SbrGoTop
   METHOD GoBottom   = SbrGoBottom
   METHOD SetFocus   = SbrSetFocus
   METHOD lIsOver    = lSbrIsOver
   METHOD cGetHotKey = cSbrGetHotKey

ENDCLASS

//----------------------------------------------------------------------------//

METHOD function SbrNew( nTop, nLeft, nLen, cText, nId, cMessage, lHorizontal )

   DEFAULT nTop = 0, nLeft = 0, nLen = 10, cText = "&ScollBar", nId = 0,;
           cMessage = "", lHorizontal = .f.

   ::Parent:New()

   ::nTop            = nTop
   ::nLeft           = nLeft
   ::nBottom         = If( lHorizontal, nTop, nTop + nLen - 1 )
   ::nRight          = If( lHorizontal, nLeft + nLen - 1, nLeft )
   ::nLen            = nLen
   ::cString         = If( lHorizontal,;
                           Chr( 17 ) + Chr( 176 ) + Chr( 16 ) + Chr( 254 ),;
                           Chr( 30 ) + Chr( 176 ) + Chr( 31 ) + Chr( 254 ) )
   ::lHorizontal     = lHorizontal
   ::cClrArrows      = "BG+/B"
   ::cClrBar         = "BG+/B"
   ::cClrThumb       = "BG+/B"
   ::cClrFocus       = "BG*+/B"
   ::nRange          = 0
   ::nValue          = 0
   ::nThumbPos       = 1
   ::nId             = nId
   ::cMessage        = cMessage
   ::oLabel          = Label():New( -1, 0, cText, 0 )
   ::oLabel:cMessage = nil
   ::oLabel:oParent  = Self

return Self

//----------------------------------------------------------------------------//

METHOD function SbrDisplay()

   local nMCrsOld := SetMCursor()

   if ::oLabel != nil
      ::oLabel:Show()
   endif

   SetMCursor( 0 )
   @ ::nAbsTop(), ::nAbsLeft() SAY SubStr( ::cString, 1, 1 ) COLOR ::cClrArrows
   if ::lHorizontal
      @ ::nAbsTop(), ::nAbsLeft() + 1 ;
        SAY Replicate( SubStr( ::cString, 2, 1 ), ::nLen - 2 ) ;
        COLOR ::cClrBar
      @ ::nAbsTop(), ::nAbsLeft() + ::nLen - 1 ;
        SAY SubStr( ::cString, 3, 1 ) COLOR ::cClrArrows
      @ ::nAbsTop(), ::nAbsLeft() + ::nThumbPos ;
        SAY SubStr( ::cString, 4, 1 ) ;
        COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
   else
      @ ::nAbsTop() + 1,;
        ::nAbsLeft(),;
        ::nAbsTop() + ::nLen - 2,;
        ::nAbsLeft() ;
        BOX SubStr( ::cString, 2, 1 ) COLOR ::cClrBar
      @ ::nAbsTop() + ::nThumbPos, ::nAbsLeft() ;
        SAY SubStr( ::cString, 4, 1 ) ;
        COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
      @ ::nAbsTop() + ::nLen - 1, ::nAbsLeft() ;
        SAY SubStr( ::cString, 3, 1 ) COLOR ::cClrArrows
   endif
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function SbrHide()

   if ::oLabel != nil
      ::oLabel:Hide()
   endif

   ::Parent:Hide()

return

//----------------------------------------------------------------------------//

METHOD function SbrSetFocus( lOnOff, cClrFocus )

   local nMCrsOld := SetMCursor()

   if ::oLabel != nil
      ::oLabel:SetFocus( lOnOff, cClrFocus )
   endif

   ::Parent:SetFocus( lOnOff, cClrFocus )

   SetMCursor( 0 )
   if ::lHorizontal
      @ ::nAbsTop(), ::nAbsLeft() + ::nThumbPos ;
        SAY SubStr( ::cString, 4, 1 ) ;
        COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
   else
      @ ::nAbsTop() + ::nThumbPos, ::nAbsLeft() ;
        SAY SubStr( ::cString, 4, 1 ) ;
        COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
   endif
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function SbrKeyPressed( nKey )

   if ::lHorizontal
      do case
         case nKey == K_LEFT
              if ::oParent != nil
                 ::oParent:SbrUp( Self )
              endif

         case nKey == K_RIGHT
              if ::oParent != nil
                 ::oParent:SbrDown( Self )
              endif
      endcase
   else
      do case
         case nKey == K_UP
              if ::oParent != nil
                 ::oParent:SbrUp( Self )
              endif

         case nKey == K_DOWN
              if ::oParent != nil
                 ::oParent:SbrDown( Self )
              endif
      endcase
   endif

return

//----------------------------------------------------------------------------//

METHOD function SbrClick( nMRow, nMCol )

   do case
      case nMRow == ::nAbsTop() .and. nMCol == ::nAbsLeft()
           if ::oParent != nil
              ::oParent:SbrUp( Self )
           endif
           MUpdate()
           do while lMpressed()
              if nMRow == ::nAbsTop() .and. nMCol == ::nAbsLeft()
                 if ::oParent != nil
                    ::oParent:SbrUp( Self )
                 endif
              endif
              MUpdate()
              nMRow = nMRow()
              nMCol = nMCol()
           enddo

      case ! ::lHorizontal
           do case                                    // PgUp
              case nMRow > ::nAbsTop() .and. ;
                   nMRow < ::nAbsTop() + ::nThumbPos .and. ;
                   nMCol == ::nAbsLeft()
                   if ::oParent != nil
                      ::oParent:SbrPgUp( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow > ::nAbsTop() .and. ;
                         nMRow < ::nAbsTop() + ::nThumbPos .and. ;
                         nMCol == ::nAbsLeft()
                         if ::oParent != nil
                            ::oParent:SbrPgUp( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo

              case nMRow > ::nAbsTop() .and. ;        // PgDn
                   nMRow > ::nAbsTop() + ::nThumbPos .and. ;
                   nMRow < ::nAbsTop() + ::nLen - 1 .and.  ;
                   nMCol == ::nAbsLeft()
                   if ::oParent != nil
                      ::oParent:SbrPgDown( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow > ::nAbsTop() .and. ;
                         nMRow > ::nAbsTop() + ::nThumbPos .and. ;
                         nMRow < ::nAbsTop() + ::nLen - 1 .and.  ;
                         nMCol == ::nAbsLeft()
                         if ::oParent != nil
                            ::oParent:SbrPgDown( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo

              case nMRow == ::nAbsTop() + ::nLen - 1 .and. ;    // Down
                   nMCol == ::nAbsLeft()
                   if ::oParent != nil
                      ::oParent:SbrDown( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow == ::nAbsTop() + ::nLen - 1 .and. ;
                         nMCol == ::nAbsLeft()
                         if ::oParent != nil
                            ::oParent:SbrDown( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo
           endcase

      case ::lHorizontal
           do case
              case nMRow == ::nAbsTop() .and. ;                // PgUp
                   nMCol > ::nAbsLeft() .and. ;
                   nMCol < ::nAbsLeft() + ::nThumbPos
                   if ::oParent != nil
                      ::oParent:SbrPgUp( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow == ::nAbsTop() .and. ;
                         nMCol > ::nAbsLeft() .and. ;
                         nMCol < ::nAbsLeft() + ::nThumbPos
                         if ::oParent != nil
                            ::oParent:SbrPgUp( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo

              case nMRow == ::nAbsTop() .and. ;                // PgDn
                   nMCol > ::nAbsLeft() + ::nThumbPos .and. ;
                   nMCol < ::nAbsLeft() + ::nLen - 2
                   if ::oParent != nil
                      ::oParent:SbrPgDown( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow == ::nAbsTop() .and. ;          // PgDn
                         nMCol > ::nAbsLeft() + ::nThumbPos .and. ;
                         nMCol < ::nAbsLeft() + ::nLen - 2
                         if ::oParent != nil
                            ::oParent:SbrPgDown( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo

              case nMRow == ::nAbsTop() .and. ;                // Down
                   nMCol == ::nAbsLeft() + ::nLen - 1
                   if ::oParent != nil
                      ::oParent:SbrDown( Self )
                   endif
                   MUpdate()
                   do while lMPressed()
                      if nMRow == ::nAbsTop() .and. ;
                         nMCol == ::nAbsLeft() + ::nLen - 1
                         if ::oParent != nil
                            ::oParent:SbrDown( Self )
                         endif
                      endif
                      MUpdate()
                      nMRow = nMRow()
                      nMCol = nMCol()
                   enddo
           endcase
   endcase

return

//----------------------------------------------------------------------------//

METHOD function SbrGoTop()

   if ::nValue != 1
      ::nValue = 1
      ::Display()
   endif

return

//----------------------------------------------------------------------------//

METHOD function SbrGoBottom()

   if ::nValue != ::nRange
      ::nValue = ::nRange
      ::Display()
   endif

return

//----------------------------------------------------------------------------//

METHOD function SbrThmCheck()

   local nNewThumbPos := Int( ( ( ::nValue - 1 ) * ( ::nLen - 3 ) ) / ;
                              ( ::nRange - 1 ) ) + 1
   local nMCrsOld := SetMCursor()

   SetMCursor( 0 )
   if ! ::lHorizontal
      if ::nThumbPos != nNewThumbPos
         ::nThumbPos = nNewThumbPos
         @ ::nAbsTop() + 1,;
           ::nAbsLeft(),;
           ::nAbsTop() + ::nLen - 2,;
           ::nAbsLeft() ;
           BOX SubStr( ::cString, 2, 1 ) COLOR ::cClrBar
         @ ::nAbsTop() + ::nThumbPos, ::nAbsLeft() ;
           SAY SubStr( ::cString, 4, 1 ) ;
           COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
      endif
   else
      if ::nThumbPos != nNewThumbPos
         ::nThumbPos = nNewThumbPos
         @ ::nAbsTop(), ::nAbsLeft() + 1 ;
           SAY Replicate( SubStr( ::cString, 2, 1 ), ::nLen - 2 ) ;
           COLOR ::cClrBar
         @ ::nAbsTop(), ::nAbsLeft() + ::nThumbPos ;
           SAY SubStr( ::cString, 4, 1 ) ;
           COLOR if( ::lFocused, ::cClrFocus, ::cClrThumb )
      endif
   endif
   SetMCursor( nMCrsOld )

return

//----------------------------------------------------------------------------//

METHOD function lSbrIsOver( nRow, nCol )

   local lIsOver := If( ::oLabel != nil, ::oLabel:lIsOver( nRow, nCol ), .f. )

   if ! lIsOver
      lIsOver = ::Parent:lIsOver( nRow, nCol )
   endif

return lIsOver

//----------------------------------------------------------------------------//

METHOD function cSbrGetHotKey()

return If( ::oLabel != nil, ::oLabel:cGetHotKey(), "" )

//----------------------------------------------------------------------------//
