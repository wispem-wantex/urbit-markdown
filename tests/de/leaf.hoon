/-  m=markdown
/+  *test, *markdown
::
::  Leaf nodes
::  ----------
::
|%
  ++  test-atx-heading
    ;:  weld
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 1 ~[[%text 'Asdf']]])
        !>((scan "# Asdf" heading:leaf:de:md))
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 4 ~[[%text 'Asdf']]])
        !>((scan "  #### Asdf\0a" heading:leaf:de:md))
      :: With trailing crap
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 1 ~[[%text 'Asdf']]])
        !>((scan "#       Asdf      \0d\0a" heading:leaf:de:md))
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 1 ~[[%text 'Asdf']]])
        !>((scan "#       Asdf      ####  " heading:leaf:de:md))
      :: With inline elements other than text
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 1 ~[[%code-span 1 'Asdf'] [%text ': A '] [%strong '*' ~[[%text 'thingy']]]]])
        !>((scan "# `Asdf`: A **thingy** #" heading:leaf:de:md))
    ==
  ++  test-setext-heading
    ;:  weld
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %setext 1 ~[[%text 'Asdf']]])
        !>((scan "Asdf\0a----------" heading:leaf:de:md))
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %setext 2 ~[[%text 'Asdf']]])
        !>((scan "  Asdf   \0a  =  " heading:leaf:de:md))
      :: With inline elements
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %setext 1 ~[[%text 'Asdf '] [%escape '*'] [%text 'Not Bold'] [%escape '*']]])
        !>((scan "Asdf \\*Not Bold\\*\0a----------" heading:leaf:de:md))
    ==
  ::
  ++  test-thematic-break
    ;:  weld
      %+  expect-eq  !>(`break:leaf:m`[%break '*' 3])  !>((scan "***\0a" break:leaf:de:md))
      :: Ends with EOF
      %+  expect-eq  !>(`break:leaf:m`[%break '_' 3])  !>((scan "___" break:leaf:de:md))
      %+  expect-eq  !>(`break:leaf:m`[%break '-' 6])  !>((scan "  ------  \0a" break:leaf:de:md))
      :: Invalid breaks
      %+  expect-eq  !>(~)  !>((rust "  ------a  \0a" break:leaf:de:md))
      %+  expect-eq  !>(~)  !>((rust "  -_-_-_  \0a" break:leaf:de:md))
    ==
  ::
  ++  test-blank-line
    ;:  weld
      %+  expect-eq  !>(`blank-line:leaf:m`[%blank-line ~])  !>((scan "\0a" blank-line:leaf:de:md))
      %+  expect-eq  !>(`blank-line:leaf:m`[%blank-line ~])  !>((scan "\0a" node:leaf:de:md))
    ==
  ::
  ++  test-codeblk-indent
    ;:  weld
      %+  expect-eq
        !>(`codeblk-indent:leaf:m`[%indent-codeblock 'an indented\0a  codeblock\0a'])
        !>((scan "    an indented\0a      codeblock" codeblk-indent:leaf:de:md))
      :: Block with blank lines in it
      %+  expect-eq
        !>(`codeblk-indent:leaf:m`[%indent-codeblock 'an indented\0a\0a  codeblock\0a'])
        !>((scan "    an indented\0a\0a      codeblock" codeblk-indent:leaf:de:md))
    ==
  ::
  ++  test-codeblk-fenced
    ;:  weld
      :: Test code fences
      %+  expect-eq  !>([3 '`' 5])  !>((scan "   `````" code-fence:codeblk-fenced:leaf:de:md))
      %+  expect-eq  !>([0 '~' 3])  !>((scan "~~~" code-fence:codeblk-fenced:leaf:de:md))
      :: Info string
      %+  expect-eq  !>('hoon')     !>((scan "  hoon" info-string:codeblk-fenced:leaf:de:md))
      ::
      :: Now, whole code blocks
      ::
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '`' 3 '' 0 'asdf\0ajkl;\0a'])
        !>((scan "```\0aasdf\0ajkl;\0a```" codeblk-fenced:leaf:de:md))
      :: With indent and info string
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '`' 3 'ruby' 2 'asdf\0ajkl;\0a'])
        !>((scan "  ``` ruby\0a  asdf\0ajkl;\0a```" codeblk-fenced:leaf:de:md))
      :: With blank lines
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '~' 5 '' 0 'asdf\0a\0ajkl;\0a'])
        !>((scan "~~~~~\0aasdf\0a\0ajkl;\0a~~~~~" codeblk-fenced:leaf:de:md))
      :: With blank line at eof
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '`' 3 '' 0 'asdf\0ajkl;\0a\0a'])
        !>((scan "```\0aasdf\0ajkl;\0a\0a```" codeblk-fenced:leaf:de:md))
      :: With no closing fence at EOF
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '`' 3 '' 0 'asdf\0ajkl;\0a'])
        !>((scan "```\0aasdf\0ajkl;\0a" codeblk-fenced:leaf:de:md))
      :: With tics and sigs in it, and closing fence indented
      %+  expect-eq
        !>(`codeblk-fenced:leaf:m`[%fenced-codeblock '~' 4 'asdf' 0 '~~~`~````\0aASD~~~~~~\0a'])
        !>((scan "~~~~asdf\0a~~~`~````\0aASD~~~~~~\0a   ~~~~" codeblk-fenced:leaf:de:md))
    ==
  ::
  ++  test-link-ref-def
    ;:  weld
      %+  expect-eq
        !>(`link-ref-def:leaf:m`[%link-ref-definition 'foo' [['/url' |] `'title']])
        !>((scan "[foo]: /url \"title\"" link-ref-def:leaf:de:md))
      :: Url on a new line
      %+  expect-eq
        !>(`link-ref-def:leaf:m`[%link-ref-definition 'foo' [['/url' |] ~]])
        !>((scan "[foo]:\0a/url" link-ref-def:leaf:de:md))
    ==
  ::
  ++  test-table
    ;:  weld
      :: Test a row
      %+  expect-eq
        !>  ^-  (list [len=@ =contents:inline:m])
            :~  :-  18  ~[[%text 'a '] [%strong '*' ~[[%text 'heading']]]]
                :-  6   ~[[%text 'b']]
                :-  2   ~[[%text 'c']]
            ==
        !>((scan "|   a **heading**  |   b  | c|" row:table:leaf:de:md))
      :: Test delimiter row
      %+  expect-eq
        !>(`(list [len=@ align=?(%n %l %c %r)])`~[[8 %l] [3 %r] [11 %c] [3 %n]])
        !>((scan "|  :---  | -:|:-----:    |---|" delimiter-row:table:leaf:de:md))
      %+  expect-eq
        !>  ^-  table:leaf:m
            :*  %table
                ~[23 15]
                ~[~[[%text 'Left columns']] ~[[%text 'Right columns']]]
                ~[%n %c]
                :~  :~(~[[%text 'left foo']] ~[[%text 'right foo']])
                    :~(~[[%text 'left '] [%link ~[[%text 'bar']] [%direct ['some-link' |] ~]]] ~[[%text 'right bar']])
                ==
            ==
        !>
        =/  a
          '''
          | Left columns   | Right columns |
          | -------------  |:-------------:|
          | left foo       | right foo     |
          | left [bar](some-link) | right bar     |
          '''
        (rash a table:leaf:de:md)
    ==
  ::
  ++  test-paragraph
    ;:  weld
      %+  expect-eq
        !>  ^-  paragraph:leaf:m
            :-  %paragraph  :~  [%text 'aaa']
                                [%soft-line-break ~]
                                [%text 'bbb']
                                [%line-break ~]
                                [%text 'ccc']
                                [%line-break ~]
                                [%text 'ddd']
                                [%soft-line-break ~]
                            ==
        !>((scan "aaa\0abbb\\\0accc  \0addd" paragraph:leaf:de:md))
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
        !>  ^-  paragraph:leaf:m
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
        !>((rash a paragraph:leaf:de:md))
    ==
  ++  test-markdown
    ;:  weld
      =/  a
        '''
        ## Milestone 1

        The first milestone for this project is support for &middot; basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.

        Reward: **2 stars**

        ## Milestone 2

        TBD, based on any potential challenges encountered in Milestone 1.
        '''
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%heading %atx 2 ~[[%text 'Milestone 1']]]]
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph   :~  [%text 'The first milestone for this project is support for ']
                                            [%entity 'middot']
                                            [%text ' basic, old-school Markdown syntax, but not']
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
        !>((rash a markdown:de:md))
      ::
      :: Some weird interaction tests
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  :+  %leaf  %paragraph   :~  [%text 'Foo']
                                            [%soft-line-break ~]
                                            [%text '    bar']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((rash 'Foo\0a    bar' markdown:de:md))
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%indent-codeblock 'foo\0a']]
                :+  %leaf  %paragraph   :~  [%text 'bar']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((rash '    foo\0abar' markdown:de:md))
    ==
--
