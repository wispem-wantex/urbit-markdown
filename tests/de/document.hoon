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
        ## Milestone 1

        The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.

        Reward: **2 stars**

        ## Milestone 2

        TBD, based on any potential challenges encountered in Milestone 1.
        '''
      %+  expect-eq
        !>  ^-  markdown:m
            :~  [%leaf [%heading %atx 2 ~[[%text 'Milestone 1']]]]
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
                [%leaf [%heading %atx 2 ~[[%text 'Milestone 2']]]]
                [%leaf [%blank-line ~]]
                :+  %leaf  %paragraph  ~[[%text 'TBD, based on any potential challenges encountered in Milestone 1.'] [%soft-line-break ~]]
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

        TBD, based on any potential challenges encountered in Milestone 1.
        '''
      =/  rslt  (rash a markdown:de:md)
      %+  expect-eq  !>(1)  !>(1)
    ==
--
