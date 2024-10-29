/-  m=markdown
/+  *test, md=markdown
::
::
::  Link helpers
::  ------------
::
|%
  ++  test-url
    ;:  weld
      ::
      :: With triangles
      %+  expect-eq  !>(`url:ln:m`['asdf jkl;' &])  !>((scan "<asdf jkl;>" url:ln:de:md))
      %+  expect-eq  !>(`url:ln:m`['' &])  !>((scan "<>" url:ln:de:md))
      %+  expect-eq  !>(`url:ln:m`['a>b' &])  !>((scan "<a\\>b>" url:ln:de:md))
      ::
      :: Without triangles
      %+  expect-eq  !>(`url:ln:m`['https://github.github.com/gfm' |])  !>((scan "https://github.github.com/gfm" url:ln:de:md))
      %+  expect-eq  !>(`url:ln:m`['https://github.github.com/(gfm)' |])  !>((scan "https://github.github.com/\\(gfm\\)" url:ln:de:md))
    ==
  ::
  ++  test-urlt
    ;:  weld
      :: In single quotes
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title text'])  !>((scan "abc 'Title text'" urlt:ln:de:md))
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title \' text'])  !>((scan "abc 'Title \\' text'" urlt:ln:de:md))
      :: In double quotes
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title text'])  !>((scan "abc \"Title text\"" urlt:ln:de:md))
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title " text'])  !>((scan "abc \"Title \\\" text\"" urlt:ln:de:md))
      :: In parentheses
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title text'])  !>((scan "abc (Title text)" urlt:ln:de:md))
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] `'Title (paren) text'])  !>((scan "abc (Title \\(paren\\) text)" urlt:ln:de:md))
      ::
      :: with no title-text
      %+  expect-eq  !>(`urlt:ln:m`[['abc' |] ~])  !>((scan "abc" urlt:ln:de:md))
    ==
  ::
  ++  test-target
    ;:  weld
      :: Direct link
      %+  expect-eq  !>(`target:ln:m`[%direct [['jkl' |] ~]])  !>((scan "(jkl)" target:ln:de:md))
      %+  expect-eq  !>(`target:ln:m`[%direct [['abc' |] `']]']])  !>((scan "(abc ']]')" target:ln:de:md))
      %+  expect-eq  !>(`target:ln:m`[%direct [['abc' |] `']]']])  !>((scan "(  abc   ']]'   )" target:ln:de:md))
      :: Reference link (full)
      %+  expect-eq  !>(`target:ln:m`[%ref %full 'abc'])  !>((scan "[abc]" target:ln:de:md))
      %+  expect-eq  !>(`target:ln:m`[%ref %full 'ab[c]'])  !>((scan "[ab\\[c\\]]" target:ln:de:md))
      :: Reference link (collapsed)
      %+  expect-eq  !>(`target:ln:m`[%ref %collapsed ''])  !>((scan "[]" target:ln:de:md))
      :: Reference link (shortcut)
      %+  expect-eq  !>(`target:ln:m`[%ref %shortcut ''])  !>((scan "" target:ln:de:md))
    ==
--
