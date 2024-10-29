/-  m=markdown
/+  *test, md=markdown
::
::  Container nodes
::  ---------------
::
|%
  ++  test-block-quote
    ;:  weld
      %+  expect-eq
        !>  "<blockquote><h2>Milestone 1</h2> <p>The first milestone for this project is support for basic, old-school Markdown syntax, but not including the Github flavor&#39;s extensions. </p> <p>Reward: <strong>2 stars</strong> </p></blockquote>"
        !>  %-  en-xml:html  %-  block-quote:container:sail-en:md
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
        !>  "<blockquote><p>According to me: </p><blockquote><p>You can put block quotes <em>inside</em> other block quotes! </p></blockquote> <p>That&#39;s pretty crazy. </p></blockquote>"
        !>  %-  en-xml:html  %-  block-quote:container:sail-en:md
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
  ++  test-task-list
    ;:  weld
       %+  expect-eq
        !>  "<ul class=\"task-list\"><li><input type=\"checkbox\" checked=\"true\" /><p>a b </p></li><li><input type=\"checkbox\" /><p>c </p></li><li><input type=\"checkbox\" checked=\"true\" /><p>d </p></li></ul>"
        !>  %-  en-xml:html  %-  tl:container:sail-en:md
          :*  %tl  0  '-'  :~
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            :-  %.n  ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            :-  %.y  ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
    ==
  ::
  ++  test-unordered-list
    ;:  weld
      %+  expect-eq
        ::!>  "- a\0a  b\0a- c\0a- d\0a"
        !>  "<ul><li><p>a b </p></li><li><p>c </p></li><li><p>d </p></li></ul>"
        !>  %-  en-xml:html  %-  ul:container:sail-en:md
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines in a list item
      %+  expect-eq
        !>  "<ul><li><p>a </p> <p>b </p></li><li><p>c </p></li><li><p>d </p></li></ul>"
        !>  %-  en-xml:html  %-  ul:container:sail-en:md
          :*  %ul  2  '*'  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines between list items
      %+  expect-eq
        !>  "<ul><li><p>a b </p> </li><li><p>c </p></li><li><p>d </p></li></ul>"
        !>  %-  en-xml:html  %-  ul:container:sail-en:md
          :*  %ul  0  '-'  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
    ==
  ::
  ++  test-ordered-list
    ;:  weld
      %+  expect-eq
        !>  "<ol start=\"4\"><li><p>a b </p></li><li><p>c </p></li><li><p>d </p></li></ol>"
        !>  %-  en-xml:html  %-  ol:container:sail-en:md
          :*  %ol  0  '.'  4  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines in a list item
      %+  expect-eq
        !>  "<ol start=\"3\"><li><p>a </p> <p>b </p></li><li><p>c </p></li><li><p>d </p></li></ol>"
        !>  %-  en-xml:html  %-  ol:container:sail-en:md
          :*  %ol  2  ')'  3  :~
            :~  [%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~]]]
                [%leaf %blank-line ~]
                [%leaf %paragraph ~[[%text 'b'] [%soft-line-break ~]]]
            ==
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
      :: With blank lines between list items
      %+  expect-eq
        !>  "<ol start=\"999999999\"><li><p>a b </p> </li><li><p>c </p></li><li><p>d </p></li></ol>"
        !>  %-  en-xml:html  %-  ol:container:sail-en:md
          :*  %ol  3  '.'  999.999.999  :~
            ~[[%leaf %paragraph ~[[%text 'a'] [%soft-line-break ~] [%text 'b'] [%soft-line-break ~]]] [%leaf %blank-line ~]]
            ~[[%leaf %paragraph ~[[%text 'c'] [%soft-line-break ~]]]]
            ~[[%leaf %paragraph ~[[%text 'd'] [%soft-line-break ~]]]]
          ==  ==
    ==
--
