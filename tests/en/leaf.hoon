/-  m=markdown
/+  *test, md=markdown
::
::  Leaf nodes
::  ----------
::
|%
  ++  test-atx-heading
    ;:  weld
      %+  expect-eq
        !>("# Asdf\0a")
        !>((heading:leaf:en:md [%heading %atx 1 ~[[%text 'Asdf']]]))
      %+  expect-eq
        !>("#### Asdf\0a")
        !>((heading:leaf:en:md [%heading %atx 4 ~[[%text 'Asdf']]]))
      :: With inline elements other than text
      %+  expect-eq
        !>("# `Asdf`: A **thingy**\0a")
        !>((heading:leaf:en:md [%heading %atx 1 ~[[%code-span 1 'Asdf'] [%text ': A '] [%strong '*' ~[[%text 'thingy']]]]]))
    ==
  ++  test-setext-heading
    ;:  weld
      %+  expect-eq
        !>("Asdf\0a----\0a")
        !>((heading:leaf:en:md [%heading %setext 1 ~[[%text 'Asdf']]]))
      %+  expect-eq
        !>("Asdf\0a====\0a")
        !>((heading:leaf:en:md [%heading %setext 2 ~[[%text 'Asdf']]]))
      :: With inline elements
      %+  expect-eq
        !>("Asdf \\*Not Bold\\*\0a-----------------\0a")
        !>((heading:leaf:en:md [%heading %setext 1 ~[[%text 'Asdf '] [%escape '*'] [%text 'Not Bold'] [%escape '*']]]))
    ==
  ::
  ++  test-thematic-break
    ;:  weld
      %+  expect-eq  !>("***\0a")  !>((break:leaf:en:md [%break '*' 3]))
      %+  expect-eq  !>("------\0a")  !>((break:leaf:en:md [%break '-' 6]))
    ==
  ::
  ++  test-blank-line
    ;:  weld
      %+  expect-eq  !>("\0a")  !>((blank-line:leaf:en:md [%blank-line ~]))
    ==
  ::
  ++  test-codeblk-indent
    ;:  weld
      %+  expect-eq
        !>("    an indented\0a      codeblock\0a")
        !>((codeblk-indent:leaf:en:md [%indent-codeblock 'an indented\0a  codeblock\0a']))
    ==
  ::
  ++  test-codeblk-fenced
    ;:  weld
      %+  expect-eq
        !>("```\0aasdf\0ajkl;\0a```\0a")
        !>((codeblk-fenced:leaf:en:md [%fenced-codeblock '`' 3 '' 0 'asdf\0ajkl;\0a']))
      :: With indent and info string
      %+  expect-eq
        !>("  ```ruby\0a  asdf\0a  jkl;\0a  ```\0a")
        !>((codeblk-fenced:leaf:en:md [%fenced-codeblock '`' 3 'ruby' 2 'asdf\0ajkl;\0a']))
      :: With blank lines
      %+  expect-eq
        !>("~~~~~\0aasdf\0a\0ajkl;\0a~~~~~\0a")
        !>((codeblk-fenced:leaf:en:md [%fenced-codeblock '~' 5 '' 0 'asdf\0a\0ajkl;\0a']))
      :: With tics and sigs in it
      %+  expect-eq
        !>("~~~~asdf\0a~~~`~````\0aASD~~~~~~\0a~~~~\0a")
        !>((codeblk-fenced:leaf:en:md [%fenced-codeblock '~' 4 'asdf' 0 '~~~`~````\0aASD~~~~~~\0a']))
    ==
  ::
  ++  test-link-ref-def
    ;:  weld
      %+  expect-eq
        !>("[foo]: /url \"title\"\0a")
        !>((link-ref-def:leaf:en:md [%link-ref-definition 'foo' [['/url' |] `'title']]))
    ==
  ::
  ++  test-table
    ;:  weld
      %+  expect-eq
        !>  %-  trip
          '''
          | Left columns          | Right columns |
          | --------------------- | :-----------: |
          | left foo              | right foo     |
          | left [bar](some-link) | right bar     |

          '''
        !>  %-  table:leaf:en:md
            :*  %table
                ~[23 15]
                ~[~[[%text 'Left columns']] ~[[%text 'Right columns']]]
                ~[%n %c]
                :~  :~(~[[%text 'left foo']] ~[[%text 'right foo']])
                    :~(~[[%text 'left '] [%link ~[[%text 'bar']] [%direct ['some-link' |] ~]]] ~[[%text 'right bar']])
                ==
            ==
      %+  expect-eq
        !>  %-  trip
          '''
          | Left columns          | Right columns |
          | :-------------------- | ------------: |
          | left foo              | right foo     |
          | left [bar](some-link) | right bar     |

          '''
        !>  %-  table:leaf:en:md
            :*  %table
                ~[23 15]
                ~[~[[%text 'Left columns']] ~[[%text 'Right columns']]]
                ~[%l %r]
                :~  :~(~[[%text 'left foo']] ~[[%text 'right foo']])
                    :~(~[[%text 'left '] [%link ~[[%text 'bar']] [%direct ['some-link' |] ~]]] ~[[%text 'right bar']])
                ==
            ==
    ==
  ::
  ++  test-paragraph
    ;:  weld
      %+  expect-eq
        !>("aaa\0abbb\\\0accc\\\0addd\0a")
        !>  %-  paragraph:leaf:en:md
            :-  %paragraph  :~  [%text 'aaa']
                                [%soft-line-break ~]
                                [%text 'bbb']
                                [%line-break ~]
                                [%text 'ccc']
                                [%line-break ~]
                                [%text 'ddd']
                                [%soft-line-break ~]
                            ==
      ::
      =/  a
        '''
        Markdown per se is *informally specified*; different platforms support slightly different versions.
        The most complete and widely adopted specification is [the Github spec](https://github.github.com/gfm),
        **which includes several *non-standard* extensions of the Markdown format**, while streamlining / removing
        the syntax in other areas. Our goal with this project is to support the Github "flavor" of Markdown,
        because many of these extensions are really popular and have effectively become part of the de facto
        standard.

        '''
      %+  expect-eq
        !>((trip a))
        !>  %-  paragraph:leaf:en:md
            :-  %paragraph  :~  [%text 'Markdown per se is ']
                                [%emphasis '*' ~[[%text 'informally specified']]]
                                [%text '; different platforms support slightly different versions.']
                                [%soft-line-break ~]
                                [%text 'The most complete and widely adopted specification is ']
                                [%link ~[[%text 'the Github spec']] [%direct ['https://github.github.com/gfm' |] ~]]
                                [%text ',']
                                [%soft-line-break ~]
                                :+  %strong  '*'  :~  [%text 'which includes several ']
                                                      [%emphasis '*' ~[[%text 'non-standard']]]
                                                      [%text ' extensions of the Markdown format']
                                                  ==
                                [%text ', while streamlining / removing']
                                [%soft-line-break ~]
                                [%text 'the syntax in other areas. Our goal with this project is to support the Github "flavor" of Markdown,']
                                [%soft-line-break ~]
                                [%text 'because many of these extensions are really popular and have effectively become part of the de facto']
                                [%soft-line-break ~]
                                [%text 'standard.']
                                [%soft-line-break ~]
                            ==
    ==
  ++  test-markdown
    ;:  weld
      =/  a
        '''
        ## Milestone 1

        The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.

        Reward: **2 stars**

        ## Milestone 2

        TBD, based on any potential challenges encountered in Milestone 1.

        '''
      %+  expect-eq
        !>((trip a))
        !>  %-  markdown:en:md
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
                [%leaf [%blank-line ~]]
                [%leaf [%heading %atx 2 ~[[%text 'Milestone 2']]]]
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph  ~[[%text 'TBD, based on any potential challenges encountered in Milestone 1.'] [%soft-line-break ~]]
            ==
    ==
--
