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
        !>((scan "  #### Asdf" heading:leaf:de:md))
      :: With trailing crap
      %+  expect-eq
        !>(`heading:leaf:m`[%heading %atx 1 ~[[%text 'Asdf']]])
        !>((scan "#       Asdf      " heading:leaf:de:md))
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
  ++  test-paragraph
    ;:  weld
      %+  expect-eq
        !>  ^-  paragraph:leaf:m
            :-  %paragraph  :~  [%text 'aaa']
                                [%soft-line-break ~]
                                [%text 'bbb']
                                [%soft-line-break ~]
                            ==
        !>((scan "aaa\0abbb" paragraph:leaf:de:md))
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

        The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.

        Reward: **2 stars**

        ## Milestone 2

        TBD, based on any potential challenges encountered in Milestone 1.
        '''
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%heading %atx 2 ~[[%text 'Milestone 1']]]
                [%blank-line ~]
                :-  %paragraph  :~  [%text 'The first milestone for this project is support for basic, old-school Markdown syntax, but not']
                                    [%soft-line-break ~]
                                    [%text 'including the Github flavor\'s extensions.']
                                    [%soft-line-break ~]
                                ==
                [%blank-line ~]
                :-  %paragraph  :~  [%text 'Reward: ']
                                    [%strong '*' ~[[%text '2 stars']]]
                                    [%soft-line-break ~]
                                ==
                [%blank-line ~]
                [%heading %atx 2 ~[[%text 'Milestone 2']]]
                [%blank-line ~]
                :-  %paragraph  ~[[%text 'TBD, based on any potential challenges encountered in Milestone 1.'] [%soft-line-break ~]]
            ==
        !>((rash a markdown:de:md))
      ::
      :: Some weird interaction tests
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  :-  %paragraph  :~  [%text 'Foo']
                                    [%soft-line-break ~]
                                    [%text '    bar']
                                    [%soft-line-break ~]
                                ==
            ==
        !>((rash 'Foo\0a    bar' markdown:de:md))
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%indent-codeblock 'foo\0a']
                :-  %paragraph  :~  [%text 'bar']
                                    [%soft-line-break ~]
                                ==
            ==
        !>((rash '    foo\0abar' markdown:de:md))
    ==
--
