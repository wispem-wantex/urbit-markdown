/-  m=markdown
/+  *test, md=markdown
::
|%
  ++  test-parsing-is-reversible
    =/  samples
      :~
        :: Grant proposal
        '''
        # Markdown on Urbit

        Markdown is a very popular, widely used and mostly-standardized document encoding format. Urbit currently has a few half-baked implementations of Markdown (e.g., Tlon has a client-side Javascript implementation; Udon supports some basic Markdown syntax), but we want a *complete, standard-compliant implementation which will allow people to create web pages in an Urbit-native fashion*. The goal is that users can reasonably expect that, e.g., a Markdown document written for Github would render and work equivalently on Urbit.

        The successful completion of this project will be a library which includes:

        1. a Markdown data type representation in Hoon
        1. a parser that can convert a valid Markdown document into this Markdown data structure
        1. renderers that can convert:

           - Markdown data structures into Sail data structures (i.e., manx and marl), which could then be passed to en-xml:html to render as HTML.
           - Markdown data structure back into raw Markdown.

        Markdown per se is informally specified; different platforms support slightly different versions. The most complete and widely adopted specification is [the Github spec](https://github.github.com/gfm), which includes several non-standard extensions of the Markdown format, while streamlining / removing the syntax in other areas. Our goal with this project is to support the Github "flavor" of Markdown, because many of these extensions are really popular and have effectively become part of the de facto standard.

        ## Milestones

        To maximize the usefulness of partially completed iterations of this project, milestones will be sliced by syntactic feature support, rather than by library components (i.e., data type, parser, and renderer). Each milestone will thus include the data structures, parser, and renderer for a portion of the Markdown syntax.

        ### Milestone 1

        The first milestone for this project is support for basic, old-school Markdown syntax, but not including the Github flavor's extensions.

        Reward: 2 stars

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

        Reward: 2 stars

        '''
        ::
        :: Markdown syntax guide
        '''
        # Markdown syntax guide

        ## Headers

        # This is a Heading h1
        ## This is a Heading h2
        ###### This is a Heading h6
        wwwwwwwww wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww `wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww

        wwwwwwwwwwwww` wwwwwwwwwwwwwwwwwww wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww wwwwwwwwwwwww wwwwwwwwwwwwwwwwwww wwwwwwwwwwwww wwwwwwwwww


        ---
        ## Emphasis

        *This text will be italic*
        _This will also be italic_

        **This text will be bold**
        __This will also be bold__

        _**You can** combine them_
        __Or the *other way* around__
        ___This one_ is tricky__
        *As is **this one***

        > According to me:
        > > You can put block quotes *inside* other block quotes!
        >
        > That's pretty crazy.

        ## Lists

        ### Unordered

        * Item 1
        * Item 2

          * Item 2a

            1. Item 2a(1)
            1. Item 2a(2)

          * Item 2b

        ### Ordered

        1. Item 1
        1. Item 2

        1. Item 3

           1. Item 3a
           1. Item 3b

        ## Images

        ![This is an alt text.](https://markdownlivepreview.com/image/sample.webp "This is a sample image.")

        ## Links

        You may be using [Markdown Live Preview](https://markdownlivepreview.com/).

        ## Blockquotes

        > Markdown is a lightweight markup language with plain-text-formatting syntax, created in 2004 by John Gruber with Aaron Swartz.
        >
        > > Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.

        ## Tables

        | Left columns              | Right columns             | Center columns            |
        | ------------------------- | ------------------------: | :-----------------------: |
        | left foo                  | right foo                 | center foo                |
        | left barasdfasfdasdf      | right barasdfasfdasdf     | center barasdfasfdasdf    |
        | left baz                  | right baz                 | center baz                |

        ## Blocks of code

        ```
        let message = 'Hello world';
        alert(message);
        ```

        ## Inline code

        This web site is using `markedjs/marked`.

        '''
        ::
        :: Some new features
        '''
        # Task lists!!!!

        This milestone adds support for the Github-flavored markdown extensions, namely:

        - [x] reference links (check [github spec][github])
        - [x] task list items
        - [x] tables
        - [ ] ~~strikethrough formatting~~
        - [ ] extended autolink

        ---

        ## And tables too

        | *Left* columns            | *Right* columns           | [Centrist] columns        |
        | ------------------------- | ------------------------: | :-----------------------: |
        | left foo                  | right foo                 | center foo                |
        | left barasdfasfdasdf      | right **barasdfasfdasdf** | center barasdfasfdasdf    |
        | left baz                  | ![](image.png)            | center baz                |

        [github]: https://github.github.com/gfm/#link-reference-definitions
        [Centrist]: https://en.wikipedia.org/wiki/Centrism

        '''
        ::
        :: Problem case
        '''
        Something Old:

        - [Robin Sloan, “Specifying Spring '83”](https://www.robinsloan.com/lab/specifying-spring-83/)
          - See also ~hanfel-dovned/board (app).
        - [Willis H. Ware, _RAND and the Information Evolution_, Chapter 3, “RAND's First Computer People”](https://www.jstor.org/stable/10.7249/cp537rc.12?seq=6)

        Something New:

        - [zorp-corp/nockapp](https://github.com/zorp-corp/nockapp)
        - [Ordinal Theory Handbook](https://docs.ordinals.com/)

        Something Borrowed:

        - [Eliran Turgeman, “On over-engineering; finding the right balance”](https://www.16elt.com/2024/09/07/future-proof-code/) (h/t Hacker News)

        Something Blue:

        - [`%wock` Hoon in the Browser `%fund`](https://urbit.iko.soy/apps/fund/project/~racfer-hattes/xwork--hoon-in-the-browser)
        - [ruth & tim, “Hypnotic Squares”](https://generativeartistry.com/tutorials/hypnotic-squares/)

        '''
      ==
    %-  zing  %+  turn  samples
    |=  [sample-doc=@t]
    ^-  tang
    %+  expect-eq
      !>(sample-doc)
      !>((crip (markdown:en:md (rash sample-doc markdown:de:md))))
--
