/-  m=markdown
/+  *test, *markdown
::
|%
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
