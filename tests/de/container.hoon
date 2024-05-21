/-  m=markdown
/+  *test, *markdown
::
::  Container nodes
::  ---------------
::
|%
  ++  test-block-quote
    ;:  weld
      =/  a
        '''
        > ## Milestone 1
        >
        > The first milestone for this project is support for basic, old-school Markdown syntax, but not
        including the Github flavor's extensions.
        >
        >Reward: **2 stars**
        '''
      %+  expect-eq
        !>  ^-  block-quote:container:m  :-  %block-quote
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
            ==
        !>((rash a block-quote:container:de:md))
      ::
      :: Check various indentation stuffs
      %+  expect-eq
        !>  ^-  block-quote:container:m  :-  %block-quote
            :~  :+  %leaf  %paragraph   :~  [%text 'Reward: 2 stars']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((scan "  > Reward: 2 stars" block-quote:container:de:md))
      %+  expect-eq
        !>  ^-  block-quote:container:m  :-  %block-quote
            :~  :+  %leaf  %paragraph   :~  [%text 'Reward:']
                                            [%soft-line-break ~]
                                            [%text '2 stars']
                                            [%soft-line-break ~]
                                        ==
            ==
        !>((scan "> Reward:\0a   > 2 stars" block-quote:container:de:md))
      ::
      ::  Nested block quotes
      =/  a
        '''
        > According to me:
        > > You can put block quotes *inside* other block quotes!
        >
        > That's pretty crazy.
        '''
      %+  expect-eq
        !>  ^-  block-quote:container:m
            :-  %block-quote
            :~  :-  %leaf  ^-  paragraph:leaf:m
                    :-  %paragraph
                    :~  [%text 'According to me:']
                        [%soft-line-break ~]
                    ==
                :+  %container
                    %block-quote
                    :~  :-  %leaf  ^-  paragraph:leaf:m
                            :-  %paragraph
                            :~  [%text 'You can put block quotes ']
                                [%emphasis '*' ~[[%text 'inside']]]
                                [%text ' other block quotes!']
                                [%soft-line-break ~]
                            ==
                    ==
                [%leaf [%blank-line ~]]
                :-  %leaf  ^-  paragraph:leaf:m
                    :-  %paragraph
                    :~  [%text 'That\'s pretty crazy.']
                        [%soft-line-break ~]
                    ==
            ==
        !>((rash a block-quote:container:de:md))
    ==
--
