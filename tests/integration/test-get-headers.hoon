/-  m=markdown
/+  *test, md=markdown
::
|%
  ++  test-get-headers
    ;:  weld
      %+  expect-eq
        !>(~[[1 "asdf jkl"] [2 "sdf2"] [4 "Heading 4"] [1 "Top heading"]])
        !>  %-  get-headers:md  %-  rash  :_  markdown:de:md
          '''
          # asdf *jkl*
          Some body text

          ## [sdf2](/some-link)
          > # jkl
          > Yeah
          > you know

          #### Heading 4
          - not much stuff
          - Yep

          # Top heading

          '''
    ==
--
