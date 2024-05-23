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
      %+  expect-eq  !>("\\*")  !>((escape:inline:en:md [%escape '*']))
    ==
  ::
  ++  test-inline-text
    ;:  weld
      %+  expect-eq  !>("A quick brown fox")  !>((text:inline:en:md [%text 'A quick brown fox']))
    ==
  ++  test-inline-entity
    ;:  weld
      %+  expect-eq  !>("&DifferentialD;")  !>((entity:inline:en:md [%entity 'DifferentialD']))
      %+  expect-eq  !>("&#17;")  !>((entity:inline:en:md [%entity '#17']))
    ==
  ++  test-inline-link
    ;:  weld
      :: Direct links
      %+  expect-eq
        !>("[the Github spec](https://github.github.com/gfm)")
        !>((link:inline:en:md [%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]]))
      %+  expect-eq
        !>("[asdf](<jkl> \"Some stuff\")")
        !>((link:inline:en:md [%link ~[[%text 'asdf']] [%direct [['jkl' &] `'Some stuff']]]))
      ::
      :: Reference link (full)
      %+  expect-eq
        !>("[asdf][jkl]")
        !>((link:inline:en:md [%link ~[[%text 'asdf']] [%ref %full 'jkl']]))
      :: Reference link (collapsed)
      %+  expect-eq
        !>("[asdf][]")
        !>((link:inline:en:md [%link ~[[%text 'asdf']] [%ref %collapsed 'asdf']]))
      :: Reference link (shortcut)
      %+  expect-eq
        !>("[asdf]")
        !>((link:inline:en:md [%link ~[[%text 'asdf']] [%ref %shortcut 'asdf']]))
    ==
  ::
  ++  test-inline-image
    ;:  weld
      %+  expect-eq
        !>("![Alt Text](url)")
        !>((image:inline:en:md [%image 'Alt Text' [%direct [['url' |] ~]]]))
      %+  expect-eq
        !>("![Alt\\] \\] Text](url)")
        !>((image:inline:en:md [%image 'Alt] ] Text' [%direct [['url' |] ~]]]))
    ==
  ::
  ++  test-inline-autolink
    ;:  weld
      %+  expect-eq
        !>("<asdf>")
        !>((autolink:inline:en:md [%autolink 'asdf']))
    ==
  ::
  ++  test-inline-emphasis
    ;:  weld
      :: With '*'
      %+  expect-eq
        !>("*the Github spec*")
        !>((emphasis:inline:en:md [%emphasis '*' ~[[%text 'the Github spec']]]))
      :: With '_'
      %+  expect-eq
        !>("_the Github spec_")
        !>((emphasis:inline:en:md [%emphasis '_' ~[[%text 'the Github spec']]]))
    ==
  ::
  ++  test-inline-strong
    ;:  weld
      :: With '*'
      %+  expect-eq
        !>("**the Github spec**")
        !>((strong:inline:en:md [%strong '*' ~[[%text 'the Github spec']]]))
      :: With '_'
      %+  expect-eq
        !>("__the Github spec__")
        !>((strong:inline:en:md [%strong '_' ~[[%text 'the Github spec']]]))
    ==
  ::
  ++  test-inline-code-block
    ;:  weld
      %+  expect-eq
        !>("```Some stuff `` with `tics` in it```")
        !>((code:inline:en:md [%code-span 3 'Some stuff `` with `tics` in it']))
      %+  expect-eq
        !>("`Some stuff `` with ```tics``` in it`")
        !>((code:inline:en:md [%code-span 1 'Some stuff `` with ```tics``` in it']))
    ==
  ::
  ::  Whole paragraphs
  ::  ----------------
  ::
  ++  test-paragraphs
    ;:  weld
      %+  expect-eq
        !>("The most complete and widely adopted specification is [the Github spec](https://github.github.com/gfm), which includes several non-standard extensions of the Markdown format")
        !>  %-  contents:inline:en:md
            :~  [%text 'The most complete and widely adopted specification is ']
                [%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]]
                [%text ', which includes several non-standard extensions of the Markdown format']
            ==
    ==
--
