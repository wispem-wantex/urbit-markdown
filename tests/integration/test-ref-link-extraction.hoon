/-  m=markdown
/+  *test, *markdown
::
:: Fixtures
=/  urlt1  [['/url' |] `'title']
=/  urlt2  [['/jfwkel' |] ~]
=/  urlt3  [['https://www.asdf.com/my-asdf' &] `'Asdf']
::
:: Helper function to construct the map literals.
:: Use `bake` to make type info work properly with `molt`
=/  make-map   (bake molt (list (pair @t urlt:ln:m)))
::
|%
  ++  test-leaf-node
    ;:  weld
      :: Leaf nodes that aren't link-ref-def should be empty
      %+  expect-eq  !>(~)  !>((process-node:all-link-ref-definitions [%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]))
      :: Link ref defs should produce 1 item
      %+  expect-eq
        !>((make-map ~[['foo' urlt1]]))
        !>((process-node:all-link-ref-definitions [%leaf [%link-ref-definition 'foo' urlt1]]))
    ==
  ::
  ++  test-block-quotes
    ;:  weld
      %+  expect-eq
        !>((make-map ~[['url1' urlt1] ['url2' urlt2]]))
        !>  %-  process-node:all-link-ref-definitions
            :-  %container
            :-  %block-quote
            :~  [%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]
                [%leaf [%link-ref-definition 'url1' urlt1]]
                :-  %container
                :-  %block-quote
                :~  [%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]
                    [%leaf [%link-ref-definition 'url2' urlt2]]
                ==
            ==
    ==
  ::
  ++  test-ol-and-ul
    ;:  weld
      %+  expect-eq
        !>((make-map ~[['url1' urlt1] ['url2' urlt2] ['url3' urlt3]]))
        !>  %-  process-node:all-link-ref-definitions
            :-  %container
            :*  %ul  0  '-'  :~
              ~[[%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]]
              ~[[%leaf [%link-ref-definition 'url1' urlt1]]]
              :~  :-  %container
                  :*  %ul  0  '-'  :~
                    ~[[%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]]
                    ~[[%leaf [%link-ref-definition 'url2' urlt2]]]
                  ==  ==
                  ::
                  :-  %container
                  :*  %ol  0  '.'  4  :~
                    ~[[%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]]
                    ~[[%leaf [%link-ref-definition 'url3' urlt3]]]
                  ==  ==
              ==
            ==  ==
    ==
  ::
  ++  test-document
    ;:  weld
      %+  expect-eq
        !>((make-map ~[['foo' urlt1]]))
        !>  %-  all-link-ref-definitions
            ^-  markdown:m
            :~  [%leaf [%blank-line ~]]
                [%leaf [%link-ref-definition 'foo' urlt1]]
            ==
    ==
--
