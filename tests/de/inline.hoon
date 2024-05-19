/-  m=markdown
/+  *test, *markdown
::
|%
  ::
  ::  Inline elements
  ::  ---------------
  ::
  ++  test-inline-escape
    ;:  weld
      %+  expect-eq  !>(`escape:inline:m`[%escape '*'])  !>((scan "\\*" escape:inline:de:md))
    ==
  ::
  ++  test-inline-text
    ;:  weld
      %+  expect-eq  !>(`text:inline:m`[%text 'A quick brown fox'])  !>((scan "A quick brown fox" text:inline:de:md))
    ==
  ++  test-inline-link
    ;:  weld
      :: Backfill helper function
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%ref %collapsed 'asdf']])
        !>((backfill-ref-link [%link ~[[%text 'asdf']] [%ref %collapsed '']]))
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%ref %shortcut 'asdf']])
        !>((backfill-ref-link [%link ~[[%text 'asdf']] [%ref %shortcut '']]))
      ::
      :: Direct links
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]])
        !>((scan "[the Github spec](https://github.github.com/gfm)" link:inline:de:md))
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%direct [['jkl' &] `'Some stuff']]])
        !>((scan "[asdf](<jkl> 'Some stuff')" link:inline:de:md))
      ::
      :: Reference link (full)
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%ref %full 'jkl']])
        !>((scan "[asdf][jkl]" link:inline:de:md))
      :: Reference link (collapsed)
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%ref %collapsed 'asdf']])
        !>((scan "[asdf][]" link:inline:de:md))
      :: Reference link (shortcut)
      %+  expect-eq
        !>(`link:inline:m`[%link ~[[%text 'asdf']] [%ref %shortcut 'asdf']])
        !>((scan "[asdf]" link:inline:de:md))
    ==
  ::
  ++  test-inline-emphasis
    ;:  weld
      :: With '*'
      %+  expect-eq
        !>(`emphasis:inline:m`[%emphasis '*' ~[[%text 'the Github spec']]])
        !>((scan "*the Github spec*" emphasis:inline:de:md))
      :: With '_'
      %+  expect-eq
        !>(`emphasis:inline:m`[%emphasis '_' ~[[%text 'the Github spec']]])
        !>((scan "_the Github spec_" emphasis:inline:de:md))
    ==
  ::
  ++  test-inline-strong
    ;:  weld
      :: With '*'
      %+  expect-eq
        !>(`strong:inline:m`[%strong '*' ~[[%text 'the Github spec']]])
        !>((scan "**the Github spec**" strong:inline:de:md))
      :: With '_'
      %+  expect-eq
        !>(`strong:inline:m`[%strong '_' ~[[%text 'the Github spec']]])
        !>((scan "__the Github spec__" strong:inline:de:md))
      :: With nested emphasis
      %+  expect-eq
        !>  ^-  strong:inline:m   :+  %strong  '*'  :~  [%text 'the ']
                                                        [%emphasis '*' ~[[%text 'Github']]]
                                                        [%text ' spec']
                                                    ==
        !>((scan "**the *Github* spec**" strong:inline:de:md))
    ==
  ::
  ++  test-inline-code-block
    ;:  weld
      %+  expect-eq
        !>(`code:inline:m`[%code-span 3 'Some stuff `` with `tics` in it'])
        !>((scan "```Some stuff `` with `tics` in it```" code:inline:de:md))
      %+  expect-eq
        !>(`code:inline:m`[%code-span 1 'Some stuff `` with ```tics``` in it'])
        !>((scan "`Some stuff `` with ```tics``` in it`" code:inline:de:md))
    ==
  ::
  ::  Whole paragraphs
  ::  ----------------
  ::
  ++  test-paragraphs
    ;:  weld
      %+  expect-eq
        !>  ^-  contents:inline:m
            :~  [%text 'The most complete and widely adopted specification is ']
                [%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]]
                [%text ', which includes several non-standard extensions of the Markdown format']
            ==
        !>((scan "The most complete and widely adopted specification is [the Github spec](https://github.github.com/gfm), which includes several non-standard extensions of the Markdown format" contents:inline:de:md))
    ==
--
