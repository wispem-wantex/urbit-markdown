/-  m=markdown
/+  *test, *markdown
::
::  Container nodes
::  ---------------
::
|%
  ++  test-block-quote
    ;:  weld
      %+  expect-eq
        !>  %-  trip
              '''
              > ## Milestone 1
              >
              > The first milestone for this project is support for basic, old-school Markdown syntax, but not
              > including the Github flavor's extensions.
              >
              > Reward: **2 stars**

              '''
        !>  %-  block-quote:container:en:md
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
      ::
      ::  Nested block quotes
      %+  expect-eq
        !>  %-  trip
          '''
          > According to me:
          > > You can put block quotes *inside* other block quotes!
          >
          > That's pretty crazy.

          '''
        !>  %-  block-quote:container:en:md
              :-  %block-quote
              :~  :-  %leaf  ^-  paragraph:leaf:m
                      :-  %paragraph
                      ^-  contents:inline:m  :~  [%text 'According to me:']
                          [%soft-line-break ~]
                      ==
                  :+  %container
                      %block-quote
                      :~  :-  %leaf  ^-  paragraph:leaf:m
                              :-  %paragraph
                              ^-  contents:inline:m  :~  [%text 'You can put block quotes ']
                                  ^-  element:inline:m  [%emphasis '*' ~[[%text 'inside']]]
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
    ==
  ::
  ++  test-unordered-list
    ;:  weld
      %+  expect-eq
        !>("- a\0a  b\0a- c\0a- d\0a")
        !>  %-  ul:container:en:md
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines in a list item
      %+  expect-eq
        !>("  * a\0a    \0a    b\0a  * c\0a  * d\0a")
        !>  %-  ul:container:en:md
          :*  %ul  2  '*'  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines in a list item, and they have spaces
      %+  expect-eq
        !>("+ a\0a  \0a  b\0a+ c\0a+ d\0a")
        !>  %-  ul:container:en:md
          :*  %ul  0  '+'  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines between list items
      %+  expect-eq
        !>("- a\0a  b\0a  \0a- c\0a- d\0a")
        !>  %-  ul:container:en:md
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
    ==
--
