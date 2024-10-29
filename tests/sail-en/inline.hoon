/-  m=markdown
/+  *test, md=markdown
::
|%
  ::
  ::  Inline elements
  ::  ---------------
  ::
  ++  test-inline-escape
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  [[%$ [%$ "*"] ~] ~]
        !>((escape:inline:sail-en:md [%escape '*']))
    ==
  ::
  ++  test-inline-text
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  [[%$ [%$ "A quick brown fox"] ~] ~]
        !>((text:inline:sail-en:md [%text 'A quick brown fox']))
    ==
  ++  test-inline-entity
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  [[%$ [%$ `tape`['&DifferentialD;' ~]] ~] ~]
        !>((entity:inline:sail-en:md [%entity 'DifferentialD']))
      %+  expect-eq
        !>  ^-  manx  [[%$ [%$ `tape`['&#17;' ~]] ~] ~]
        !>((entity:inline:sail-en:md [%entity '#17']))
    ==
  ++  test-inline-link
    =/  ref-links=(map @t urlt:ln:m)  %-  molt  :~
      ['asdf' `urlt:ln:m`[['https://ref.link' |] ~]]
      ['jkl' `urlt:ln:m`[['https://another.link' |] `'Sample']]
    ==
    ;:  weld
      :: Direct links
      %+  expect-eq
        !>  ^-  manx  ;a(href "https://github.github.com/gfm", title ""): the Github spec
        !>((link:inline:sail-en:md [%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]]))
      %+  expect-eq
        !>  ^-  manx  ;a(href "jkl", title "Some stuff"): asdf
        !>((link:inline:sail-en:md [%link ~[[%text 'asdf']] [%direct [['jkl' &] `'Some stuff']]]))
      ::
      :: Reference link (full)
      %+  expect-eq
        !>  ^-  manx  ;a(href "https://another.link", title "Sample"): asdf
        !>((link:~(inline sail-en:md ref-links) [%link ~[[%text 'asdf']] [%ref %full 'jkl']]))
      :: Reference link (collapsed)
      %+  expect-eq
        !>  ^-  manx  ;a(href "https://ref.link", title ""): asdf
        !>((link:~(inline sail-en:md ref-links) [%link ~[[%text 'asdf']] [%ref %collapsed 'asdf']]))
      :: Reference link (shortcut)
      %+  expect-eq
        !>  ^-  manx  ;a(href "https://ref.link", title ""): asdf
        !>((link:~(inline sail-en:md ref-links) [%link ~[[%text 'asdf']] [%ref %shortcut 'asdf']]))
    ==
  ::
  ++  test-inline-image
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;img(src "url", alt "Alt Text");
        !>((image:inline:sail-en:md [%image 'Alt Text' [%direct [['url' |] ~]]]))
      %+  expect-eq
        !>  ^-  manx  ;img(src "url", alt "Alt] ] Text");
        !>((image:inline:sail-en:md [%image 'Alt] ] Text' [%direct [['url' |] ~]]]))
    ==
  ::
  ++  test-inline-autolink
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;a(href "asdf"): asdf
        !>((autolink:inline:sail-en:md [%autolink 'asdf']))
    ==
  ::
  ++  test-inline-emphasis
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;em: the Github spec
        !>((emphasis:inline:sail-en:md [%emphasis '*' ~[[%text 'the Github spec']]]))
    ==
  ::
  ++  test-inline-strong
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;strong: the Github spec
        !>((strong:inline:sail-en:md [%strong '*' ~[[%text 'the Github spec']]]))
    ==
  ::
  ++  test-inline-strikethru
    %+  expect-eq
      !>  ^-  manx  ;strike: oops
      !>((strikethru:inline:sail-en:md [%strikethru 1 ~[[%text 'oops']]]))
  ::
  ++  test-inline-code-block
    ;:  weld
      %+  expect-eq
        !>  ;code: {"Some stuff `` with `tics` in it"}
        !>((code:inline:sail-en:md [%code-span 3 'Some stuff `` with `tics` in it']))
    ==
  ::
  ::  Whole paragraphs
  ::  ----------------
  ::
  ++  test-paragraphs
    ;:  weld
      %+  expect-eq
        !>  ^-  marl  :~  [[%$ [%$ "The most "] ~] ~]
                          ;strike: complete and
                          [[%$ [%$ " widely adopted specification is "] ~] ~]
                          ;a(href "https://github.github.com/gfm", title ""): the Github spec
                          [[%$ [%$ ", which includes several non-standard extensions of the Markdown format"] ~] ~]
                      ==
        !>  %-  contents:inline:sail-en:md
            :~  [%text 'The most ']
                :-  %html  ;strike: complete and
                [%text ' widely adopted specification is ']
                [%link ~[[%text 'the Github spec']] [%direct [['https://github.github.com/gfm' |] ~]]]
                [%text ', which includes several non-standard extensions of the Markdown format']
            ==
    ==
--
