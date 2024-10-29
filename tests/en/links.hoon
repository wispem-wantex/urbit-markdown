/-  m=markdown
/+  *test, md=markdown
::
::
::  Same test cases  as from `/tests/de`, but in reverse!
::  -----------------------------------------------------
::
|%
  ++  test-url
    ;:  weld
      ::
      :: With triangles
      %+  expect-eq  !>("<asdf jkl;>")  !>((url:ln:en:md ['asdf jkl;' &]))
      %+  expect-eq  !>("<>")           !>((url:ln:en:md ['' &]))
      %+  expect-eq  !>("<a\\>b>")      !>((url:ln:en:md ['a>b' &]))
      ::
      :: Without triangles
      %+  expect-eq  !>("https://github.github.com/gfm")  !>((url:ln:en:md ['https://github.github.com/gfm' |]))
      %+  expect-eq  !>("https://github.github.com/\\(gfm\\)")  !>((url:ln:en:md ['https://github.github.com/(gfm)' |]))
    ==
  ::
  ++  test-urlt
    ;:  weld
      :: In single quotes
      %+  expect-eq  !>("abc \"Title text\"")  !>((urlt:ln:en:md [['abc' |] `'Title text']))
      %+  expect-eq  !>("abc \"Title ' text\"")  !>((urlt:ln:en:md [['abc' |] `'Title \' text']))
      %+  expect-eq  !>("abc \"Title \\\" text\"")  !>((urlt:ln:en:md [['abc' |] `'Title " text']))
      ::
      :: with no title-text
      %+  expect-eq  !>("abc")  !>((urlt:ln:en:md [['abc' |] ~]))
    ==
  ::
  ++  test-target
    ;:  weld
      :: Direct link
      %+  expect-eq  !>("(jkl)")         !>((target:ln:en:md [%direct [['jkl' |] ~]]))
      %+  expect-eq  !>("(abc \"]]\")")  !>((target:ln:en:md [%direct [['abc' |] `']]']]))
      :: Reference link (full)
      %+  expect-eq  !>("[abc]")         !>((target:ln:en:md [%ref %full 'abc']))
      %+  expect-eq  !>("[ab\\[c\\]]")   !>((target:ln:en:md [%ref %full 'ab[c]']))
      :: Reference link (collapsed)
      %+  expect-eq  !>("[]")            !>((target:ln:en:md [%ref %collapsed '']))
      :: Reference link (shortcut)
      %+  expect-eq  !>("")              !>((target:ln:en:md [%ref %shortcut '']))
    ==
--
