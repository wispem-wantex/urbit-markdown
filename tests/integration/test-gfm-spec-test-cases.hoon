/-  m=markdown
/+  *test, *markdown
::
::=/  expect-parse-to-html                          :: Assert equivalent HTML
::  |=  [md=@t html=@t]
::  %+  expect-eq
::    !>((sail-en (rash md markdown:de:^md)))
::    !>  ^-  manx  ;div
::          ;+  (rash html apex:de-xml:^html)
::        ==
=/  expect-md
  |=  [txt=@t =markdown:m]
  %+  expect-eq
    !>(markdown)
    !>((rash txt markdown:de:md))
|%
  ++  test-3-1-blocks-and-inlines
    %+  expect-md
      '''
      - `one
      - two`
      '''
      :~  :-  %container  :*  %ul  0  '-'
                              :~  `markdown:m`~[[%leaf %paragraph ~[[%text '`one'] [%soft-line-break ~]]]]
                                  `markdown:m`~[[%leaf %paragraph ~[[%text 'two`'] [%soft-line-break ~]]]]
                              ==
                          ==
      ==
  ::
  ++  test-4-1-thematic-breaks
    ;:  weld
      :: example 13
      %+  expect-md
        '''
        ***
        ---
        ___
        '''
        :~  [%leaf `node:leaf:m`[%break '*' 3]]
            [%leaf `node:leaf:m`[%break '-' 3]]
            [%leaf `node:leaf:m`[%break '_' 3]]
        ==
      :: example 16
      %+  expect-md
        '''
        --
        **
        __
        '''
        :~  [%leaf %paragraph ~[[%text '--'] [%soft-line-break ~] [%text '**'] [%soft-line-break ~] [%text '__'] [%soft-line-break ~]]]
        ==
      :: example 17
      %+  expect-md
        '''
         ***
          ***
           ***
        '''
        :~  [%leaf `node:leaf:m`[%break '*' 3]]
            [%leaf `node:leaf:m`[%break '*' 3]]
            [%leaf `node:leaf:m`[%break '*' 3]]
        ==
      :: example 18
      %+  expect-md
        '''
            ***
        '''
        :~  [%leaf %indent-codeblock '***\0a']
        ==
      :: example 19
      %+  expect-md
        '''
        Foo
            ***
        '''
        :~  [%leaf %paragraph ~[[%text 'Foo'] [%soft-line-break ~] [%text '    ***'] [%soft-line-break ~]]]
        ==
      :: example 20
      %+  expect-md
        '''
        _____________________________________
        '''
        :~  [%leaf `node:leaf:m`[%break '_' 37]]
        ==
      :: example 26
      %+  expect-md
        '''
         *-*
        '''
        :~  [%leaf %paragraph ~[[%text ' '] [%emphasis '*' ~[[%text '-']]] [%soft-line-break ~]]]
        ==
      :: example 27
      %+  expect-md
        '''
        - foo
        ***
        - bar
        '''
        :~  :-  %container  :*  %ul  0  '-'
                              :~  `markdown:m`~[[%leaf %paragraph ~[[%text 'foo'] [%soft-line-break ~]]]]
                              ==
                            ==
            [%leaf `node:leaf:m`[%break '*' 3]]
            :-  %container  :*  %ul  0  '-'
                              :~  `markdown:m`~[[%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]]
                              ==
                            ==
      ==
      :: example 28
      %+  expect-md
        '''
        Foo
        ***
        bar
        '''
        :~  [%leaf %paragraph ~[[%text 'Foo'] [%soft-line-break ~]]]
            [%leaf `node:leaf:m`[%break '*' 3]]
            [%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]
        ==
      :: example 29
      %+  expect-md
        '''
        Foo
        ---
        bar
        '''
        :~  [%leaf %heading %setext 1 ~[[%text 'Foo']]]
            [%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]
        ==
    ==
  ::
  ++  test-4-2-atx-headings
    ;:  weld
      :: example 34
      %+  expect-md
        '''
        #5 bolt

        #hashtag
        '''
        :~  [%leaf %paragraph ~[[%text '#5 bolt'] [%soft-line-break ~]]]
            [%leaf %blank-line ~]
            [%leaf %paragraph ~[[%text '#hashtag'] [%soft-line-break ~]]]
        ==
      :: example 35
      %+  expect-md
        '''
        \## foo
        '''
        :~  [%leaf %paragraph ~[[%text '\\## foo'] [%soft-line-break ~]]]
        ==
      :: example 36
      %+  expect-md
        '''
        # foo *bar* \*baz\*
        '''
        :~  [%leaf %heading %atx 1 ~[[%text 'foo '] [%emphasis '*' ~[[%text 'bar']]] [%text ' '] [%escape '*'] [%text 'baz'] [%escape '*']]]
        ==
      :: example 39
      %+  expect-md
        '''
            # foo
        '''
        :~  [%leaf %indent-codeblock '# foo\0a']
        ==
      :: example 40
      %+  expect-md
        '''
        foo
            # bar
        '''
        :~  [%leaf %paragraph ~[[%text 'foo'] [%soft-line-break ~] [%text '    # bar'] [%soft-line-break ~]]]
        ==
      :: example 41, 42, 44, 45
      %+  expect-md
        '''
        ## foo ##
          ###   bar    ###
        # foo ##################################
        ##### foo ##
        ### foo ### b
        # foo#
        '''
        :~  [%leaf %heading %atx 2 ~[[%text 'foo']]]
            [%leaf %heading %atx 3 ~[[%text 'bar']]]
            [%leaf %heading %atx 1 ~[[%text 'foo']]]
            [%leaf %heading %atx 5 ~[[%text 'foo']]]
            [%leaf %heading %atx 3 ~[[%text 'foo ### b']]]
            [%leaf %heading %atx 1 ~[[%text 'foo#']]]
        ==
      :: example 46
      %+  expect-md
        '''
        ### foo \###
        ## foo #\##
        # foo \#
        '''
        :~  [%leaf %heading %atx 3 ~[[%text 'foo \\###']]]
            [%leaf %heading %atx 2 ~[[%text 'foo #\\##']]]
            [%leaf %heading %atx 1 ~[[%text 'foo \\#']]]
        ==
      :: example 47, 48
      %+  expect-md
        '''
        ****
        ## foo
        ****
        Foo bar
        # baz
        Bar foo
        '''
        :~  [%leaf [%break '*' 4]]
            [%leaf %heading %atx 2 ~[[%text 'foo']]]
            [%leaf [%break '*' 4]]
            [%leaf %paragraph ~[[%text 'Foo bar'] [%soft-line-break ~]]]
            [%leaf %heading %atx 1 ~[[%text 'baz']]]
            [%leaf %paragraph ~[[%text 'Bar foo'] [%soft-line-break ~]]]
        ==
    ==
  ::
  ++  test-4-4-indented-code-blocks
    ;:  weld
      :: example 77
      %+  expect-md
        '''
            a simple
              indented code block
        '''
        :~  [%leaf %indent-codeblock 'a simple\0a  indented code block\0a']
        ==
      :: example 78
      %+  expect-md
        '''
          - foo

            bar
        '''
        :~  :-  %container  :*  %ul  2  '-'
                              :~  :~  [%leaf %paragraph ~[[%text 'foo'] [%soft-line-break ~]]]
                                      [%leaf %blank-line ~]
                                      [%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]
                                  ==
                              ==
                            ==
        ==
      :: example 79
      %+  expect-md
        '''
        1.  foo

            - bar
        '''
        :~  :-  %container  :*  %ol  0  '.'  1
                      :~  :~  [%leaf %paragraph ~[[%text 'foo'] [%soft-line-break ~]]]
                              [%leaf %blank-line ~]
                              :-  %container  :*  %ul  0  '-'
                                :~  :~  [%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]
                                    ==
                                ==
                              ==
                          ==
                      ==
                    ==
        ==
      :: example 80
      %+  expect-md
        '''
            <a/>
            *hi*

            - one
        '''
        :~  [%leaf %indent-codeblock '<a/>\0a*hi*\0a\0a- one\0a']
        ==
      :: example 84
      %+  expect-md
        '''
            foo
        bar
        '''
        :~  [%leaf %indent-codeblock 'foo\0a']
            [%leaf %paragraph ~[[%text 'bar'] [%soft-line-break ~]]]
        ==
      :: example 86
      %+  expect-md
        '''
                foo
            bar
        '''
        :~  [%leaf %indent-codeblock '    foo\0abar\0a']
        ==
    ==
--
