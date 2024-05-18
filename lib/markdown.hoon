/-  m=markdown
::

=>  |%
      :: Set label for collapsed / shortcut reference links
      ++  backfill-ref-link
        |=  [a=link:inline:m]
        ^-  link:inline:m
        =/  t  target.a
        ?+  -.t  a                    :: only reference links
          %ref
            ?:  =(%full type.t)  a                   :: only collapsed / shortcut links
            =/  node=element:inline.m  (head contents.a)
            ?+  -.node  a                :: ...and it's a %text node
              %text
                %_  a
                  target  %_  t
                    label  text.node
                  ==
                ==
            ==
        ==
    --
|%
  ::
  ::  Parse to and from Markdown text format
  ++  md
    |%
      ++  de                                               ::  de:md  Deserialize (parse)
        |%
          ++  whitespace  (mask " \09\0a")                 ::  whitespace: space, tab, or newline
          ++  escaped
            |=  [char=@t]
            (cold char (jest (crip (snoc "\\" char))))
          ::
          ++  ln                                           ::  Links and urls
            |%
              ++  url
                =<  %+  cook  |=(a=url:ln:m a)                 :: Cast
                    ;~(pose with-triangles without-triangles)
                |%
                  ++  with-triangles
                    ;~  plug
                      ::(cook crip (ifix [gal gar] (star ;~(less whitespace (full gar) prn))))
                      %+  cook  crip
                        %+  ifix  [gal gar]
                        %-  star
                        ;~  pose
                          (escaped '<')
                          (escaped '>')
                          ;~(less gal gar (just '\0a') prn)    :: Anything except '<', '>' or newline
                        ==
                      (easy %.y)                               :: "yes triangles"
                    ==
                  ++  without-triangles
                    ;~  plug
                      %+  cook  crip
                        ;~  less
                            gal                                :: Doesn't start with '<'
                            %-  plus                           :: Non-empty
                              ;~  less
                                  whitespace                   :: No whitespace allowed
                                  ;~  pose
                                    (escaped '(')
                                    (escaped ')')
                                    ;~(less pal par (just '\0a') prn)    :: Anything except '(', ')' or newline
                                  ==
                              ==
                        ==
                      (easy %.n)                               :: "no triangles"
                    ==
                --
              ::
              ++  urlt
                %+  cook  |=(a=urlt:ln:m a)                :: Cast
                ;~  plug
                  url
                  %-  punt                                 :: Optional title-text
                    ;~  pfix  (plus whitespace)            :: Separated by some whitespace
                      %+  cook  crip  ;~  pose             :: Enclosed in single quote, double quote, or '(...)'
                        (ifix [soq soq] (star ;~(pose (escaped '\'') ;~(less soq prn))))
                        (ifix [doq doq] (star ;~(pose (escaped '"') ;~(less doq prn))))
                        (ifix [pal par] (star ;~(pose (escaped '(') (escaped ')') ;~(less pal par prn))))
                      ==
                    ==
                ==
              ::
              ::  Labels are used in inline link targets and in a block-level element (labeled link references)
              ++  label
                %+  cook  crip
                %+  ifix  [sel ser]                        :: Enclosed in '[...]'
                %+  ifix  :-  (star whitespace)            :: Strip leading and trailing whitespapce
                              (star whitespace)
                %-  plus  ;~  pose                         :: Non-empty
                  (escaped '[')
                  (escaped ']')
                  ;~(less sel ser prn)                     :: Anything except '<', '>'
                ==
              ::
              ++  target                                   :: Link target, either reference or direct
                =<  %+  cook  |=(a=target:ln:m a)
                    ;~(pose target-direct target-ref)
                |%
                  ++  target-direct
                    %+  cook  |=(a=target:ln:m a)
                    %+  stag  %direct
                    %+  ifix  [pal par]                        :: Direct links are enclosed in '(...)'
                    %+  ifix  :-  (star whitespace)            :: Strip leading and trailing whitespace
                                  (star whitespace)
                    urlt                                       :: Just the target
                  ++  target-ref
                    %+  cook  |=(a=target:ln:m a)
                    %+  stag  %ref
                    ;~  pose
                      %+  stag  %full  label
                      %+  stag  %collapsed  (cold '' (jest '[]'))
                      %+  stag  %shortcut  (easy '')
                    ==
                --
            --
          ++  inline       :: Inline elements
            |%
              ++  contents  (cook |=(a=contents:inline:m a) (star element))                 :: Element sequence
              ++  element                                  :: Any element
                %+  cook  |=(a=element:inline:m a)
                ;~  pose
                  escape
                  strong
                  emphasis
                  code
                  link
                  text
                ==
              ::
              ++  text
                %+  knee  *text:inline:m  |.  ~+   :: recurse
                %+  cook  |=(a=text:inline:m a)
                %+  stag  %text
                %+  cook  crip
                %-  plus                                   :: At least one character
                ;~  less                                   :: ...which doesn't match any other inline rule
                  escape
                  link
                  emphasis
                  strong
                  code
                  :: ...etc
                  ::(fall extra-excludes fail)
                  prn
                ==
              ::
              ++  escape
                %+  cook  |=(a=escape:inline:m a)
                %+  stag  %escape
                ;~  pose
                  ::  \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
                  (escaped '[')  (escaped ']')  (escaped '(')  (escaped ')')
                  (escaped '!')  (escaped '*')  (escaped '*')  (escaped '_')
                  :: etc
                ==
              ::
              ++  link
                %+  knee  *link:inline:m  |.  ~+   :: recurse
                %+  cook  backfill-ref-link
                %+  stag  %link
                ;~  plug
                  %+  ifix  [sel ser]                      :: Display text is wrapped in '[...]'
                    %-  star  ;~  pose                     :: Display text can contain various contents
                      escape
                      :: code
                      :: image
                       ::emphasis
                      :: NOT links
                      %+  knee  *text:inline:m  |.  ~+   :: recurse
                      %+  cook  |=(a=text:inline:m a)
                      %+  stag  %text
                      %+  cook  crip
                      %-  plus                                   :: At least one character
                      ;~  less                                   :: ...which doesn't match any other inline rule
                        escape
                        link
                        emphasis
                        :: strong
                        :: ...etc
                        ser                                   :: No closing ']'
                        prn
                      ==
                    ==
                  target:ln
                ==
              ::
              ++  emphasis
                %+  knee  *emphasis:inline:m  |.  ~+   :: recurse
                %+  cook  |=(a=emphasis:inline:m a)
                %+  stag  %emphasis
                ;~  pose
                  %+  ifix  [tar tar]
                    ;~  plug
                      (easy '*')
                      %-  plus  ;~  pose                     :: Display text can contain various contents
                        escape
                        :: code
                        :: image
                        link
                        %+  knee  *text:inline:m  |.  ~+   :: recurse
                        %+  cook  |=(a=text:inline:m a)
                        %+  stag  %text
                        %+  cook  crip
                        %-  plus                                   :: At least one character
                        ;~  less                                   :: ...which doesn't match any other inline rule
                          escape
                          link
                          emphasis
                          :: strong
                          :: ...etc
                          tar                              :: If a '*', then it's not text it's the end of the `emphasis`
                          prn
                        ==
                      ==
                    ==
                  %+  ifix  [cab cab]
                    ;~  plug
                      (easy '_')
                      %-  plus  ;~  pose                     :: Display text can contain various contents
                        escape
                        :: code
                        :: image
                        link
                        %+  knee  *text:inline:m  |.  ~+   :: recurse
                        %+  cook  |=(a=text:inline:m a)
                        %+  stag  %text
                        %+  cook  crip
                        %-  plus                                   :: At least one character
                        ;~  less                                   :: ...which doesn't match any other inline rule
                          escape
                          link
                          emphasis
                          :: strong
                          :: ...etc
                          cab                              :: If a '*', then it's not text it's the end of the `emphasis`
                          prn
                        ==
                      ==
                    ==
                ==
              ::
              ++  strong
                %+  knee  *strong:inline:m  |.  ~+   :: recurse
                %+  cook  |=(a=strong:inline:m a)
                %+  stag  %strong
                ;~  pose
                  %+  ifix  [(jest '**') (jest '**')]
                    ;~  plug
                      (easy '*')
                      %-  plus  ;~  pose                     :: Display text can contain various contents
                        escape
                        :: code
                        :: image
                        link
                        %+  knee  *text:inline:m  |.  ~+   :: recurse
                        %+  cook  |=(a=text:inline:m a)
                        %+  stag  %text
                        %+  cook  crip
                        %-  plus                                   :: At least one character
                        ;~  less                                   :: ...which doesn't match any other inline rule
                          escape
                          link
                          emphasis
                          :: strong
                          :: ...etc
                          (jest '**')                              :: If a '**', then it's not text it's the end of the `emphasis`
                          prn
                        ==
                      ==
                    ==
                  %+  ifix  [(jest '__') (jest '__')]
                    ;~  plug  (easy '_')
                      %-  plus  ;~  pose                     :: Display text can contain various contents
                        escape
                        :: code
                        :: image
                        link
                        %+  knee  *text:inline:m  |.  ~+   :: recurse
                        %+  cook  |=(a=text:inline:m a)
                        %+  stag  %text
                        %+  cook  crip
                        %-  plus                                   :: At least one character
                        ;~  less                                   :: ...which doesn't match any other inline rule
                          escape
                          link
                          emphasis
                          :: strong
                          :: ...etc
                          (jest '__')                              :: If a '**', then it's not text it's the end of the `emphasis`
                          prn
                        ==
                      ==
                    ==
                ==
              ::
              ++  code
                =<  %+  cook  |=(a=code:inline:m a)
                    %+  stag  %code-span
                    inner-parser
                |%
                  ++  inner-parser
                    |=  =nail
                    =/  vex  ((plus tic) nail)                    :: Read the first backtick string
                    ?~  q.vex  vex  :: If no vex is found, fail
                    =/  tic-sequence  ^-  tape  p:(need q.vex)
                    %.
                      q:(need q.vex)
                    %+  cook  |=  [a=tape]                        :: Attach the backtick length to it
                              [(lent tic-sequence) (crip a)]
                    ;~  sfix
                      %+  cook
                        |=  [a=(list tape)]
                        ^-  tape
                        (zing a)
                      %-  star  ;~  pose
                          %+  cook  trip  ;~(less tic prn)          :: Any character other than a backtick
                          %+  sear                       :: A backtick string that doesn't match the opener
                            |=  [a=tape]
                            ^-  (unit tape)
                            ?:  =((lent a) (lent tic-sequence))
                              ~
                            `a
                          (plus tic)
                        ==
                      (jest (crip tic-sequence))                    :: Followed by a closing backtick string
                    ==
                --
            --
        --
      ::
      ::  Enserialize (write out as text)
      ++  en
        |%
          ++  escape-chars
            |=  [text=@t chars=(list @t)]
            ^-  tape
            %+  rash  text
            %+  cook
              |=(a=(list tape) `tape`(zing a))
            %-  star  ;~  pose
              (cook |=(a=@t `tape`~['\\' a]) (mask chars))
              (cook trip prn)
              ::(cold `tape`['\\' ] gal) (cold "\\>" gar) (cook trip prn))))
            ==
          ::
          ++  ln
            |%
              ++  url
                =<  |=  [u=url:ln:m]
                    ^-  tape
                    ?:  has-triangle-brackets.u
                      (with-triangles text.u)
                    (without-triangles text.u)
                |%
                  ++  with-triangles
                    |=  [text=@t]
                    ;:  weld
                      "<"                    :: Put it inside triangle brackets
                      (escape-chars text "<>") :: Escape triangle brackets in the text
                      ">"
                    ==
                  ++  without-triangles
                    |=  [text=@t]
                    (escape-chars text "()")               :: Escape all parentheses '(' and ')'
                --
              ++  urlt
                |=  [u=urlt:ln:m]
                ^-  tape
                ?~  title-text.u      :: If there's no title text, then it's just an url
                  (url url.u)
                ;:(weld (url url.u) " \"" (escape-chars (need title-text.u) "\"") "\"")
              ++  label
                |=  [text=@t]
                ^-  tape
                ;:(weld "[" (escape-chars text "[]") "]")
              ++  target
                |=  [t=target:ln:m]
                ^-  tape
                ?-  -.t
                  %direct   ;:(weld "(" (urlt urlt.t) ")")          :: Wrap in parentheses
                  ::
                  %ref      ?-  type.t
                              %full       (label label.t)
                              %collapsed  "[]"
                              %shortcut   ""
                            ==
                ==
            --
          ::
          ++  inline
            |%
              ++  contents
                |=  [=contents:inline:m]
                ^-  tape
                %-  zing  %+  turn  contents  element
              ++  element
                |=  [e=element:inline:m]
                ?+  -.e  !!
                  %text  (text e)
                  %link  (link e)
                  %escape  (escape e)
                  %code-span  (code e)
                  %strong  (strong e)
                  %emphasis  (emphasis e)
                  :: ...etc
                ==
              ++  text
                |=  [t=text:inline:m]
                ^-  tape
                (trip text.t)                                     :: So easy!
              ::
              ++  link
                |=  [l=link:inline:m]
                ^-  tape
                ;:  weld
                  "["
                  (contents contents.l)
                  "]"
                  (target:ln target.l)
                ==
              ::
              ++  escape
                |=  [e=escape:inline:m]
                ^-  tape
                (snoc "\\" char.e)                 :: Could use `escape-chars` but why bother-- this is shorter
              ::
              ++  code
                |=  [c=code:inline:m]
                ^-  tape
                ;:(weld (reap num-backticks.c '`') (trip text.c) (reap num-backticks.c '`'))
              ::
              ++  strong
                |=  [s=strong:inline:m]
                ^-  tape
                ;:  weld
                  (reap 2 emphasis-char.s)
                  (contents contents.s)
                  (reap 2 emphasis-char.s)
                ==
              ::
              ++  emphasis
                |=  [e=emphasis:inline:m]
                ^-  tape
                ;:  weld
                  (trip emphasis-char.e)
                  (contents contents.e)
                  (trip emphasis-char.e)
                ==
            --
        --
    --
  ::
  ::  Enserialize as Sail (manx and marl)
  ++  sail-en
    |%
      ++  inline
        |_  [reference-links=(map @t urlt:ln:m)]
          ++  contents
            |=  [=contents:inline:m]
            ^-  marl
            %+  turn  contents  element
          ++  element
            |=  [e=element:inline:m]
            ^-  manx
            ?+  -.e  !!
              %text  (text e)
              %link  (link e)
              %code-span  (code e)
              %escape  (escape e)
              %strong  (strong e)
              %emphasis  (emphasis e)
              :: ...etc
            ==
          ++  text
            |=  [t=text:inline:m]
            ^-  manx
            [[%$ [%$ (trip text.t)] ~] ~]  :: Magic; look up the structure of a `manx` if you want
          ++  escape
            |=  [e=escape:inline:m]
            ^-  manx
            [[%$ [%$ (trip char.e)] ~] ~]  :: Magic; look up the structure of a `manx` if you want
          ++  code
            |=  [c=code:inline:m]
            ^-  manx
            ;code: {(trip text.c)}
          ++  link
            |=  [l=link:inline:m]
            ^-  manx
            =/  target  target.l
            =/  urlt  ?-  -.target
                          %direct  urlt.target                                 :: Direct link; use it
                          %ref     (~(got by reference-links) label.target)    :: Ref link; look it up
                      ==
            ;a(href (trip text.url.urlt), title (trip (fall title-text.urlt '')))
              ;*  (contents contents.l)
            ==
          ++  emphasis
            |=  [e=emphasis:inline:m]
            ^-  manx
            ;em
              ;*  (contents contents.e)
            ==
          ++  strong
            |=  [s=strong:inline:m]
            ^-  manx
            ;strong
              ;*  (contents contents.s)
            ==
        --
    --
--
