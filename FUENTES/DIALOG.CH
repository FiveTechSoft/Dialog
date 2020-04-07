//----------------------------------------------------------------------------//

#xcommand DEFAULT <xVar1> = <xDefaultValue1>                                  ;
               [, <xVarN> = <xDefaultValueN> ] =>                             ;
                  <xVar1> = If( <xVar1> == nil, <xDefaultValue1>, <xVar1> );  ;
                [ <xVarN> = If( <xVarN> == nil, <xDefaultValueN>, <xVarN> );]

#xcommand CLASS <cClassName> [ FROM <cSuperName> ] => ;
          CLASS <cClassName> [ _FROM <cSuperName>() ]

#xcommand CLASS <cClassName> [ _FROM <cSuperName> ] =>                       ;
                                                                             ;
          function <cClassName>()                                            ;;
             static Class                                                    ;;
             if Class == nil                                                 ;;
                Class = ClassMaker():New( <"cClassName"> [,<{cSuperName}>] ) ;;
                Class:AddMethod( "Parent", "ClsParent" )

#xcommand VAR <cVar1> [,<cVarN>] => ;
                Class:AddVar( <"cVar1"> ) [; Class:AddVar( <"cVarN"> ) ]

#xcommand METHOD <cMethodName> = <cUdfName> => ;
                Class:AddMethod( <"cMethodName">, <"cUdfName"> )

#xcommand ENDCLASS =>               ;
                Class:Make()        ;;
             end                    ;;
          return Class:oInstance()

#xcommand METHOD function <cName> => function <cName>         ;;
                                        local Self := QSelf()

#xtranslate :: => Self:

#xtranslate Parent:<method>([<parms,...>]) => ;
            Parent( Upper( <"method"> ) [,<parms>] )

//----------------------------------------------------------------------------//
