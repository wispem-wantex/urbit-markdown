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
  ++  test-document-with-ref-links
    ;:  weld
      %+  expect-eq
        !>  "<div><p><a href=\"/url1\" title=\"\">Go!</a></p> </div>"
        !>  %-  en-xml:html  %-  sail-en:md
            ^-  markdown:m
            :~  [%leaf [%paragraph ~[[%link ~[[%text 'Go!']] [%ref %full 'foo']]]]]
                [%leaf [%link-ref-definition 'foo' [['/url1' |] ~]]]
            ==
      ::
      %+  expect-eq
        !>  "<div><p><a href=\"/my-img\" title=\"Img\"><img src=\"/my-img\" alt=\"An image\" /></a></p> </div>"
        !>  %-  en-xml:html  %-  sail-en:md
            ^-  markdown:m
            :~  [%leaf [%paragraph ~[[%link ~[[%image 'An image' [%ref %full 'foo']]] [%ref %full 'foo']]]]]
                [%leaf [%link-ref-definition 'foo' [['/my-img' |] `'Img']]]
            ==
    ==
  ++  test-big-doc
    =/  a
      '''
      # Urbit

      [Urbit](https://urbit.org) is a personal server stack built from scratch. It
      has an identity layer (Azimuth), virtual machine (Vere), and operating system
      (Arvo).

      A running Urbit "ship" is designed to operate with other ships peer-to-peer.
      Urbit is a general-purpose, peer-to-peer computer and network.

      This repository contains the [Arvo Kernel][arvo]

      For the Runtime, see [Vere][vere].
      For more on the identity layer, see [Azimuth][azim].
      To manage your Urbit identity, use [Bridge][brid].

      ## Install

      To install and run Urbit, please follow the instructions at
      [urbit.org/getting-started][start]. You'll be on the live network in a
      few minutes.

      [start]: https://urbit.org/getting-started/

      ## Contributing

      Contributions of any form are more than welcome!  Please take a look at our
      [contributing guidelines][cont] for details on our git practices, coding
      styles, and how we manage issues.

      You might also be interested in joining the [urbit-dev][list] mailing list.

      ## Release

      For details about our release process, see the [maintainers guidelines][main]

      [arvo]: https://github.com/urbit/urbit/tree/master/pkg/arvo
      [azim]: https://github.com/urbit/azimuth
      [brid]: https://github.com/urbit/bridge
      [vere]: https://github.com/urbit/vere
      [list]: https://groups.google.com/a/urbit.org/forum/#!forum/dev
      [cont]: https://github.com/urbit/urbit/blob/master/CONTRIBUTING.md
      [main]: https://github.com/urbit/urbit/blob/master/MAINTAINERS.md
      '''
    =/  data  (rash a markdown:de:md)
    =/  aytchtml  (sail-en data)
    %+  expect-eq
      !>(`[['https://github.com/urbit/urbit/tree/master/pkg/arvo' |] ~])
      !>((~(get by (all-link-ref-definitions data)) 'arvo'))
--
