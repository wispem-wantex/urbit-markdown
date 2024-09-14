/-  m=markdown
/+  *test, *markdown
::
::  Container nodes
::  ---------------
::
|%
  ++  test-block-quote
    ;:  weld
      =/  a
        '''
        > ## Milestone 1
        >
        > The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.
        >
        >Reward: **2 stars**
        '''
      %+  expect-eq
        !>  ^-  block-quote:container:m
          :-  %block-quote
          :~  [%leaf [%heading %atx 2 ~[[%text 'Milestone 1']]]]
              [%leaf [%blank-line ~]]
              :+  %leaf  %paragraph   :~  [%text 'The first milestone for this project is support for basic, old-school Markdown syntax, but not']
                                          [%soft-line-break ~]
                                          [%text 'including the Github flavor\'s extensions.']
                                          [%soft-line-break ~]
                                      ==
              [%leaf [%blank-line ~]]
              :+  %leaf  %paragraph   :~  [%text 'Reward: ']
                                          [%strong '*' ~[[%text '2 stars']]]
                                          [%soft-line-break ~]
                                      ==
          ==
        !>((rash a block-quote:container:de:md))
      ::
      :: Check various indentation stuffs
      %+  expect-eq
        !>  ^-  block-quote:container:m
          :-  %block-quote
          :~  :+  %leaf  %paragraph   :~  [%text 'Reward: 2 stars']
                                          [%soft-line-break ~]
                                      ==
          ==
        !>((scan "  > Reward: 2 stars" block-quote:container:de:md))
      %+  expect-eq
        !>  ^-  block-quote:container:m
          :-  %block-quote
          :~  :+  %leaf  %paragraph   :~  [%text 'Reward:']
                                          [%soft-line-break ~]
                                          [%text '2 stars']
                                          [%soft-line-break ~]
                                      ==
          ==
        !>((scan "> Reward:\0a   > 2 stars" block-quote:container:de:md))
      ::
      ::  Nested block quotes
      =/  a
        '''
        > According to me:
        > > You can put block quotes *inside* other block quotes!
        >
        > That's pretty crazy.
        '''
      %+  expect-eq
        !>  ^-  block-quote:container:m
            :-  %block-quote
            :~  :-  %leaf  ^-  paragraph:leaf:m
                    :-  %paragraph
                    :~  [%text 'According to me:']
                        [%soft-line-break ~]
                    ==
                :+  %container
                    %block-quote
                    :~  :-  %leaf  ^-  paragraph:leaf:m
                            :-  %paragraph
                            :~  [%text 'You can put block quotes ']
                                [%emphasis '*' ~[[%text 'inside']]]
                                [%text ' other block quotes!']
                                [%soft-line-break ~]
                            ==
                    ==
                [%leaf [%blank-line ~]]
                :-  %leaf  ^-  paragraph:leaf:m
                    :-  %paragraph
                    :~  [%text 'That\'s pretty crazy.']
                        [%soft-line-break ~]
                    ==
            ==
        !>((rash a block-quote:container:de:md))
    ==
  ::
  ::  Unordered lists
  ::  ---------------
  ::
  ++  test-ul-marker
    ;:  weld
      %+  expect-eq  !>([0 '-' 2])  !>((scan "- " ul-marker:container:de:md))
      %+  expect-eq  !>([2 '+' 5])  !>((scan "  +  " ul-marker:container:de:md))
      %+  expect-eq  !>([3 '*' 5])  !>((scan "   * " ul-marker:container:de:md))
    ==
  ::
  ++  test-unordered-list-item
    ;:  weld
      %+  expect-eq
        !>(`ul-item-t:container:de:md`['-' 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "- asdf\0a  jkl;" ul-item:container:de:md))
      :: With only 1 line
      %+  expect-eq
        !>(`ul-item-t:container:de:md`['-' 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~]]]]])
        !>((scan "- asdf" ul-item:container:de:md))
      :: With hanging indent
      %+  expect-eq
        !>(`ul-item-t:container:de:md`['-' 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text '  jkl;'] [%soft-line-break ~]]]]])
        !>((scan "- asdf\0a    jkl;" ul-item:container:de:md))
      :: With leading indent
      %+  expect-eq
        !>(`ul-item-t:container:de:md`['+' 3 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "   + asdf\0a     jkl;" ul-item:container:de:md))
    ==
  ::
  ++  test-unordered-list
    ;:  weld
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- a\0a  b\0a- c\0a- d" ul:container:de:md))
      :: With blank lines in a list item
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  2  '*'  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "  * a\0a\0a    b\0a  * c\0a  * d" ul:container:de:md))
      :: With blank lines in a list item, and they have spaces
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  0  '+'  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "+   a\0a    \0a    b\0a+   c\0a+   d" ul:container:de:md))
      :: With blank lines between list items
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- a\0a  b\0a\0a- c\0a- d" ul:container:de:md))
      :: With blank lines with spaces between list items
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- a\0a  b\0a  \0a- c\0a- d" ul:container:de:md))
      :: List items can interrupt paragraphs
      =/  txt
        '''
        Item 1
        - Item 2
        '''
      %+  expect-eq
        !>((rash txt markdown:de:md))
        !>  ^-  markdown:m  :~
              ^-  node:markdown:m  [%leaf %paragraph ~[[%text 'Item 1'] [%soft-line-break ~]]]
              ^-  node:markdown:m  :-  %container  :*  %ul  0  '-'  :~
                :~  ^-  node:markdown:m  [%leaf [%paragraph contents=~[[%text text='Item 2'] [%soft-line-break ~]]]]
                ==
              ==  ==
            ==
      :: Nested lists
      %+  expect-eq
        !>  ^-  ul:container:m
          :*  %ul  0  '-'  :~
            ^-  markdown:m  :~
              ^-  node:markdown:m  [%leaf [%paragraph contents=~[[%text text='Robin Sloan'] [%soft-line-break ~]]]]
              ::
              ^-  node:markdown:m  :-  %container
              ^-  ul:container:m  :*  %ul  0  '-'  :~
                ~[[%leaf [%paragraph contents=~[[%text text='~hanfel-dovned'] [%soft-line-break ~]]]]]
              ==  ==
            ==
          ==  ==
        !>((scan "- Robin Sloan\0a  - ~hanfel-dovned" ul:container:de:md))
    ==
  ::
  ::  Ordered lists
  ::  ---------------
  ::
  ++  test-ol-marker
    ;:  weld
      %+  expect-eq  !>([0 '.' 1 3])  !>((scan "1. " ol-marker:container:de:md))
      %+  expect-eq  !>([2 ')' 98.776 11])  !>((scan "  98776)   " ol-marker:container:de:md))
    ==
  ::
  ++  test-ordered-list-item
    ;:  weld
      %+  expect-eq
        !>(`ol-item-t:container:de:md`['.' 1 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "1. asdf\0a   jkl;" ol-item:container:de:md))
      :: With only 1 line
      %+  expect-eq
        !>(`ol-item-t:container:de:md`[')' 3 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~]]]]])
        !>((scan "3)  asdf" ol-item:container:de:md))
      :: With hanging indent
      %+  expect-eq
        !>(`ol-item-t:container:de:md`[')' 23 0 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text '  jkl;'] [%soft-line-break ~]]]]])
        !>((scan "23) asdf\0a      jkl;" ol-item:container:de:md))
      :: With leading indent
      %+  expect-eq
        !>(`ol-item-t:container:de:md`['.' 900 3 ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "   900. asdf\0a        jkl;" ol-item:container:de:md))
    ==
  ::
  ++  test-ordered-list
    ;:  weld
      %+  expect-eq
        !>  ^-  ol:container:m
          :*  %ol  0  '.'  4  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "4. a\0a   b\0a2. c\0a3. d" ol:container:de:md))
      :: With blank lines in a list item
      %+  expect-eq
        !>  ^-  ol:container:m
          :*  %ol  2  ')'  3  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "  3) a\0a\0a     b\0a  20) c\0a  1) d" ol:container:de:md))
      :: With blank lines in a list item, and they have spaces
      %+  expect-eq
        !>  ^-  ol:container:m
          :*  %ol  0  ')'  0  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "0)   a\0a     \0a     b\0a1)   c\0a2)   d" ol:container:de:md))
      :: With blank lines between list items
      %+  expect-eq
        !>  ^-  ol:container:m
          :*  %ol  0  '.'  1.000  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "1000. a\0a      b\0a\0a1001. c\0a1002. d" ol:container:de:md))
      :: With blank lines with spaces between list items
      %+  expect-eq
        !>  ^-  ol:container:m
          :*  %ol  3  '.'  999.999.999  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "   999999999. a\0a              b\0a              \0a   0. c\0a1000000000000. d" ol:container:de:md))
    ==
  ::
  ::  Task lists
  ::  ----------
  ::
  ++  test-tl-checkbox
    ;:  weld
      %+  expect-eq  !>(%.y)  !>((scan "[x]" tl-checkbox:container:de:md))
      %+  expect-eq  !>(%.n)  !>((scan "[ ]" tl-checkbox:container:de:md))
    ==
  ::
  ++  test-task-list-item
    ;:  weld
      %+  expect-eq
        !>(`tl-item-t:container:de:md`['-' 0 %.n ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "- [ ] asdf\0a  jkl;" tl-item:container:de:md))
      :: With only 1 line
      %+  expect-eq
        !>(`tl-item-t:container:de:md`['-' 0 %.y ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~]]]]])
        !>((scan "- [x] asdf" tl-item:container:de:md))
      :: With hanging indent
      %+  expect-eq
        !>(`tl-item-t:container:de:md`['-' 0 %.n ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text '  jkl;'] [%soft-line-break ~]]]]])
        !>((scan "- [ ] asdf\0a    jkl;" tl-item:container:de:md))
      :: With leading indent
      %+  expect-eq
        !>(`tl-item-t:container:de:md`['+' 3 %.y ~[[%leaf %paragraph ~[[%text 'asdf'] [%soft-line-break ~] [%text 'jkl;'] [%soft-line-break ~]]]]])
        !>((scan "   + [x] asdf\0a     jkl;" tl-item:container:de:md))
    ==
  ::
  ++  test-task-list
    ;:  weld
      %+  expect-eq
        !>  ^-  tl:container:m
          :*  %tl  0  '-'  :~
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- [x] a\0a  b\0a- [ ] c\0a- [x] d" tl:container:de:md))
      :: With blank lines in a list item
      %+  expect-eq
        !>  ^-  tl:container:m
          :*  %tl  2  '*'  :~
            :-  %.n  :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "  * [ ] a\0a\0a    b\0a  * [ ] c\0a  * [ ] d" tl:container:de:md))
      :: With blank lines in a list item, and they have spaces
      %+  expect-eq
        !>  ^-  tl:container:m
          :*  %tl  0  '+'  :~
            :-  %.y  :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "+   [x] a\0a    \0a    b\0a+   [x] c\0a+   [x] d" tl:container:de:md))
      :: With blank lines between list items
      %+  expect-eq
        !>  ^-  tl:container:m
          :*  %tl  0  '-'  :~
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- [x] a\0a  b\0a\0a- [ ] c\0a- [ ] d" tl:container:de:md))
      :: With blank lines with spaces between list items
      %+  expect-eq
        !>  ^-  tl:container:m
          :*  %tl  0  '-'  :~
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
        !>((scan "- [ ] a\0a  b\0a  \0a- [x] c\0a- [ ] d" tl:container:de:md))
    ==
--
