/-  m=markdown
/+  *test, md=markdown
::
:: Fixtures
=/  urlt1=urlt:ln:m  [['/url' |] `'title']
=/  urlt2=urlt:ln:m  [['/jfwkel' |] ~]
::
|%
  ++  test-leaf-node
    ;:  weld
      :: Test single image
      %+  expect-eq
        !>(`text:url:urlt1)
        !>((process-inline:get-preview-img:md [%image 'jkl' [%direct urlt1]]))
      :: Test image with ref link
      %+  expect-eq
        !>(`text:url:urlt1)
        !>((~(process-inline get-preview-img:md (molt ~[['asdf' urlt1]])) [%image 'jkl' [%ref %full 'asdf']]))
      :: Test node with no images
      %+  expect-eq
        !>(~)
        !>((process-node:get-preview-img:md [%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]))
      :: Items with image should produce 1 item
      %+  expect-eq
        !>(`text:url:urlt2)
        !>((process-node:get-preview-img:md [%leaf [%paragraph ~[[%text 'text'] [%image 'jkl' [%direct urlt2]]]]]))
      :: Items with 2 image should produce still only 1 item
      %+  expect-eq
        !>(`text:url:urlt1)
        !>  %-  process-node:get-preview-img:md
            :-  %container
            :-  %block-quote
            :~  [%leaf [%heading %atx 1 ~[[%text 'Asdf']]]]
                [%leaf [%paragraph ~[[%image 'url1' [%direct urlt1]]]]]
                :-  %container
                :-  %block-quote
                :~  [%leaf [%heading %atx 1 ~[[%text 'Asdf'] [%image 'url2' [%direct urlt2]]]]]
                    [%leaf [%link-ref-definition 'url2' urlt2]]
                ==
            ==
    ==
--
