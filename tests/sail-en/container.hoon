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
--
