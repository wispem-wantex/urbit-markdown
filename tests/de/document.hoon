/-  m=markdown
/+  *test, *markdown
::
::  Whole documents
::  ---------------
::
|%
  ++  test-misc
    ;:  weld
      %+  expect-eq
        !>('\0a')
        !>((scan "\0d\0a" newline:de:md))
    ==
  ::
  ++  test-markdown
    ;:  weld
      :: With carriage returns
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%heading %atx 1 ~[[%text 'Markdown on Urbit']]]]
                [%leaf [%blank-line ~]]
                [%leaf [%paragraph ~[[%text 'a'] [%soft-line-break ~]]]]
            ==
        !>((rash '# Markdown on Urbit\0d\0a\0d\0aa' markdown:de:md))
      ::
      =/  a
        '''
        1. a thing
        2. other thing
        3. thing 3
        '''
      %+  expect-eq
        !>  ^-  markdown:m
          :~  :-  %container
            :*  %ol  0  '.'  1  :~
              ~[[%leaf %paragraph ~[[%text 'a thing'] [%soft-line-break ~]]]]
              ~[[%leaf %paragraph ~[[%text 'other thing'] [%soft-line-break ~]]]]
              ~[[%leaf %paragraph ~[[%text 'thing 3'] [%soft-line-break ~]]]]
            ==  ==
          ==
        !>((rash a markdown:de:md))
      ::
      =/  a
        '''
        ```
        let message = 'Hello world';
        alert(message);
        ```
        '''
      %+  expect-eq
        !>
            ^-  markdown:m
            :~  :-  %leaf
              [%fenced-codeblock '`' 3 '' 0 'let message = \'Hello world\';\0aalert(message);\0a']
            ==
        !>((rash a markdown:de:md))
      ::
      =/  a
        '''
        ### Milestone 1

        The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.

        Reward: **2 stars**

        ### Milestone 2

        This milestone adds support for the Github-flavored markdown extensions, namely:

        - [ ] reference links
        - [x] task list items
        - [ ] tables
        - [ ] strikethrough formatting
        - [ ] extended autolink
        - [ ] embedded HTML

        Additionally, it includes:

          - comprehensive edge-case testing

          - documentation of how to use the library in an app

          - an example app showing how the library can be used, with a front-end

        Yep.
        '''
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%heading %atx 3 ~[[%text 'Milestone 1']]]]
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph   :~  [%text 'The first milestone for this project is support for basic, old-school Markdown syntax, but not']
                                            [%soft-line-break ~]
                                            [%text 'including the Github flavor\'s extensions.']
                                            [%soft-line-break ~]
                                        ==
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph   :~  [%text 'Reward: ']
                                            [%strong '*' ~[[%text '2 stars']]]
                                            [%soft-line-break ~]
                                        ==
                [%leaf [%blank-line ~]]
                [%leaf [%heading %atx 3 ~[[%text 'Milestone 2']]]]
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph  ~[[%text 'This milestone adds support for the Github-flavored markdown extensions, namely:'] [%soft-line-break ~]]
                [%leaf [%blank-line ~]]
                :-  %container  :*  %tl  0  '-'  :~
                  :-  %.n  ~[[%leaf %paragraph ~[[%text 'reference links'] [%soft-line-break ~]]]]
                  :-  %.y  ~[[%leaf %paragraph ~[[%text 'task list items'] [%soft-line-break ~]]]]
                  :-  %.n  ~[[%leaf %paragraph ~[[%text 'tables'] [%soft-line-break ~]]]]
                  :-  %.n  ~[[%leaf %paragraph ~[[%text 'strikethrough formatting'] [%soft-line-break ~]]]]
                  :-  %.n  ~[[%leaf %paragraph ~[[%text 'extended autolink'] [%soft-line-break ~]]]]
                  :-  %.n  ~[[%leaf %paragraph ~[[%text 'embedded HTML'] [%soft-line-break ~]]] [%leaf [%blank-line ~]]]
                ==  ==
                :+  %leaf  %paragraph  ~[[%text 'Additionally, it includes:'] [%soft-line-break ~]]
                [%leaf [%blank-line ~]]
                ^-  node:markdown:m  :-  %container  :*  %ul  2  '-'  :~
                  :~  [%leaf %paragraph ~[[%text 'comprehensive edge-case testing'] [%soft-line-break ~]]]
                      [%leaf [%blank-line ~]]
                  ==
                  :~  [%leaf %paragraph ~[[%text 'documentation of how to use the library in an app'] [%soft-line-break ~]]]
                      [%leaf [%blank-line ~]]
                  ==
                  :~  [%leaf %paragraph ~[[%text 'an example app showing how the library can be used, with a front-end'] [%soft-line-break ~]]]
                      [%leaf [%blank-line ~]]
                  ==
                ==  ==
                :+  %leaf  %paragraph  ~[[%text 'Yep.'] [%soft-line-break ~]]
            ==
        !>((rash a markdown:de:md))
      ::
      :: Some weird interaction tests
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  :+  %leaf  %paragraph   :~  [%text 'Foo']
                                            [%soft-line-break ~]
                                            [%text '    bar']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((rash 'Foo\0a    bar' markdown:de:md))
      ::
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%indent-codeblock 'foo\0a']]
                :+  %leaf  %paragraph   :~  [%text 'bar']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((rash '    foo\0abar' markdown:de:md))
      ::
      =/  a
        '''
        # Markdown on Urbit

        Markdown is a very popular, widely used and mostly-standardized document encoding format. Urbit currently has a few half-baked implementations of Markdown (e.g., Tlon has a client-side Javascript implementation; Udon supports some basic Markdown syntax), but we want a *complete, standard-compliant implementation which will allow people to create web pages in an Urbit-native fashion*. The goal is that users can reasonably expect that, e.g., a Markdown document written for Github would render and work equivalently on Urbit.

        The successful completion of this project will be a library which includes:
        1. a Markdown data type representation in Hoon
        2. a parser that can convert a valid Markdown document into this Markdown data structure
        3. a renderer that can convert Markdown data structures into Sail data structures (i.e., manx and marl), which could then be passed to en-xml:html to render as HTML.

        Markdown per se is informally specified; different platforms support slightly different versions. The most complete and widely adopted specification is [the Github spec](https://github.github.com/gfm), which includes several non-standard extensions of the Markdown format, while streamlining / removing the syntax in other areas. Our goal with this project is to support the Github "flavor" of Markdown, because many of these extensions are really popular and have effectively become part of the de facto standard.

        To maximize the usefulness of partially completed iterations of this project, milestones will be sliced by syntactic feature support, rather than by library components (i.e., data type, parser, and renderer). Each milestone will thus include the data structures, parser, and renderer for a portion of the Markdown syntax.

        ## Milestone 1

        The first milestone for this project is support for basic, old-school Markdown syntax, but not including the Github flavor's extensions.

        Reward: 2 stars

        ## Milestone 2

        This milestone adds support for the Github-flavored markdown extensions, namely:

          - [ ] reference links
          - [x] task list items
          - [ ] tables
          - [ ] strikethrough formatting
          - [ ] extended autolink
          - [ ] embedded HTML

        Additionally, it includes:

        - comprehensive edge-case testing
        - documentation of how to use the library in an app
        - an example app showing how the library can be used, with a front-end

        '''
      %+  expect-eq  !>(a)  !>((crip (markdown:en:md (rash a markdown:de:md))))
    ==
--
