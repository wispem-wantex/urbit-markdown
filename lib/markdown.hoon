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
          ++  line-end                                     :: Either EOL or EOF
            ;~(pose (just '\0a') (full (easy ~)))
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
                  image
                  autolink
                  text
                  softbrk
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
                  image
                  autolink
                  emphasis
                  strong
                  code
                  softbrk
                  :: ...etc
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
              ++  softbrk                                  :: Newline
                %+  cook  |=(a=softbrk:inline:m a)
                %+  stag  %soft-line-break
                (cold ~ (just '\0a'))
              ::
              ++  link
                %+  knee  *link:inline:m  |.  ~+   :: recurse
                %+  cook  backfill-ref-link
                %+  stag  %link
                ;~  plug
                  %+  ifix  [sel ser]                      :: Display text is wrapped in '[...]'
                    %-  star  ;~  pose                     :: Display text can contain various contents
                      escape
                      emphasis
                      strong
                      code
                      :: Text: =>
                      %+  knee  *text:inline:m  |.  ~+   :: recurse
                      %+  cook  |=(a=text:inline:m a)
                      %+  stag  %text
                      %+  cook  crip
                      %-  plus                                   :: At least one character
                      ;~  less                                   :: ...which doesn't match any other inline rule
                        escape
                        emphasis
                        strong
                        code
                        ser                                   :: No closing ']'
                        prn
                      ==
                    ==
                  target:ln
                ==
              ::
              ++  image
                %+  cook  |=(a=image:inline:m a)
                %+  stag  %image
                ;~  plug
                  %+  ifix  [(jest '![') (just ']')]       :: alt-text is wrapped in '![...]'
                    %+  cook  crip
                    %-  star  ;~  pose
                      (escaped ']')
                      ;~(less ser prn)
                    ==
                  target:ln
                ==
              ::
              ++  autolink
                %+  cook  |=(a=autolink:inline:m a)
                %+  stag  %autolink
                %+  ifix  [gal gar]                       :: Enclosed in '<...>'
                %+  cook  crip
                %-  star  ;~  pose
                  ;~(less ace gar prn)                    :: Spaces are not allowed; neither are backslash-escapes
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
                        emphasis
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
          ::
          ++  leaf
            |%
              ++  node
                %+  cook  |=(a=node:leaf:m a)
                ;~  pose
                  blank-line
                  heading
                  break
                  :: ...etc
                  paragraph
                ==
              ++  blank-line
                %+  cook  |=(a=blank-line:leaf:m a)
                %+  stag  %blank-line
                (cold ~ (just '\0a'))
              ++  heading
                =<  %+  cook  |=(a=heading:leaf:m a)
                    %+  stag  %heading
                    ;~(pose atx setext)
                |%
                  ++  atx
                    =/  atx-eol   ;~  plug
                                    (star ace)
                                    (star hax)
                                    (star ace)
                                    line-end
                                  ==

                    %+  stag  %atx
                    %+  cook                               :: Parse heading inline content
                      |=  [level=@ text=tape]
                      [level (scan text contents:inline)]
                    ;~  pfix
                      (stun [0 3] ace)                     :: Ignore up to 3 leading spaces
                      ;~  plug
                        (cook |=(a=tape (lent a)) (stun [1 6] hax))                   :: Heading level
                        ::%+  cook
                        ::  |=([a=tape] (scan text contents:inline))
                        %+  ifix  [(plus ace) atx-eol]     :: One leading space is required; rest is ignored
                          %-  star
                          ;~(less atx-eol prn)             :: Trailing haxes/spaces are ignored
                      ==
                    ==
                  ++  setext
                    %+  stag  %setext
                    %+  cook
                      |=  [text=tape level=@]
                      [level (scan text contents:inline)]
                    ;~  plug                                   :: Wow this is a mess
                      %+  ifix  [(stun [0 3] ace) (star ace)]  :: Strip up to 3 spaces, and trailing space
                        (star ;~(less ;~(pfix (star ace) (just '\0a')) prn))     :: Any text...
                      ;~  pfix
                        (just '\0a')                         :: ...followed by newline...
                        (stun [0 3] ace)                     :: ...up to 3 spaces (stripped)...
                        ;~  sfix
                          ;~  pose                             :: ...and an underline
                            (cold 1 (plus (just '-')))         :: Underlined by '-' means heading lvl 1
                            (cold 2 (plus (just '=')))         :: Underlined by '=' means heading lvl 2
                          ==
                          (star ace)
                        ==
                      ==
                    ==
                --
              ++  break
                %+  cook  |=(a=break:leaf:m a)
                %+  stag  %break
                %+  cook
                  |=  [first-2=@t trailing=tape]
                  [(head trailing) (add 2 (lent trailing))]
                %+  ifix  :-  (stun [0 3] ace)                  :: Strip indent and trailing space
                              ;~  plug
                                (star (mask " \09"))
                                (just '\0a')                    :: No other chars allowed on the line
                              ==
                  ;~  pose
                    ;~(plug (jest '**') (plus tar))       :: At least 3, but can be more
                    ;~(plug (jest '--') (plus hep))
                    ;~(plug (jest '__') (plus cab))
                  ==
              ++  paragraph
                %+  cook  |=(a=paragraph:leaf:m a)
                %+  stag  %paragraph
                %+  cook                                   :: Reparse the paragraph text as elements
                  |=  [a=(list tape)]
                  (scan (zing a) contents:inline)
                %-  plus                                   :: Read lines until a non-paragraph object is found
                  ;~  less
                    heading
                    break
                    %+  cook  snoc  ;~  plug
                      %-  plus  ;~(less (jest '\0a') prn)  :: Lines must be non-empty
                      (cold '\0a' line-end)
                    ==
                  ==
            --
          ++  markdown
            (star node:leaf)
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
                  %soft-line-break  (softbrk e)
                  %image  (image e)
                  %autolink  (autolink e)
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
              ++  image
                |=  [i=image:inline:m]
                ^-  tape
                ;:  weld
                  "!["
                  (escape-chars alt-text.i "]")
                  "]"
                  (target:ln target.i)
                ==
              ::
              ++  autolink
                |=  [a=autolink:inline:m]
                ^-  tape
                ;:  weld
                  "<"
                  (trip text.a)
                  ">"
                ==
              ::
              ++  escape
                |=  [e=escape:inline:m]
                ^-  tape
                (snoc "\\" char.e)                 :: Could use `escape-chars` but why bother-- this is shorter
              ::
              ++  softbrk
                |=  [s=softbrk:inline:m]
                ^-  tape
                "\0a"
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
          ::
          ++  leaf
            |%
              ++  node
                |=  [n=node:leaf:m]
                ?+  -.n  !!
                  %blank-line  (blank-line n)
                  %break  (break n)
                  %heading  (heading n)
                  %paragraph  (paragraph n)
                  :: ...etc
                ==

              ++  blank-line
                |=  [b=blank-line:leaf:m]
                ^-  tape
                "\0a"
              ::
              ++  break
                |=  [b=break:leaf:m]
                ^-  tape
                (weld (reap char-count.b char.b) "\0a")
              ::
              ++  heading
                |=  [h=heading:leaf:m]
                ^-  tape
                ?-  style.h
                  %atx
                    ;:(weld (reap level.h '#') " " (contents:inline contents.h) "\0a")
                  %setext
                    =/  line  (contents:inline contents.h)
                    ;:(weld line "\0a" (reap (lent line) ?:(=(level.h 1) '-' '=')) "\0a")
                ==
              ++  paragraph
                |=  [p=paragraph:leaf:m]
                ^-  tape
                (contents:inline contents.p)
            --
          ++  markdown
            |=  [m=markdown:m]
            ^-  tape
            %-  zing  %+  turn  m  node:leaf
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
              %soft-line-break  (softbrk e)
              %image  (image e)
              %autolink  (autolink e)
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
          ++  softbrk
            |=  [s=softbrk:inline:m]
            ^-  manx
            (text [%text ' '])
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
          ++  image
            |=  [i=image:inline:m]
            ^-  manx
            =/  target  target.i
            =/  urlt  ?-  -.target
                          %direct  urlt.target                                 :: Direct link; use it
                          %ref     (~(got by reference-links) label.target)    :: Ref link; look it up
                      ==
            ;img(href (trip text.url.urlt), alt (trip alt-text.i));
          ++  autolink
            |=  [a=autolink:inline:m]
            ^-  manx
            ;a(href (trip text.a)): {(trip text.a)}
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
      ++  leaf
        |_  [reference-links=(map @t urlt:ln:m)]
          ++  node
            |=  [n=node:leaf:m]
            ^-  manx
            ?+  -.n  !!
              %blank-line  (blank-line n)
              %break  (break n)
              %heading  (heading n)
              %paragraph  (paragraph n)
              :: ...etc
            ==
          ++  heading
            |=  [h=heading:leaf:m]
            ^-  manx
            :-
              :_  ~   ?+  level.h  !!
                        %1  %h1
                        %2  %h2
                        %3  %h3
                        %4  %h4
                        %5  %h5
                        %6  %h6
                      ==
            (~(contents inline reference-links) contents.h)
          ++  blank-line
            |=  [b=blank-line:leaf:m]
            ^-  manx
            (text:inline [%text ' '])
          ++  break
            |=  [b=break:leaf:m]
            ^-  manx
            ;hr;
          ++  paragraph
            |=  [p=paragraph:leaf:m]
            ^-  manx
            ;p
              ;*  (~(contents inline reference-links) contents.p)
            ==
        --
      ++  markdown
        |=  [m=markdown:m]
        ^-  manx
        ;html
          ;body
            ;*  %+  turn  m  node:leaf
          ==
        ==
    --
--
