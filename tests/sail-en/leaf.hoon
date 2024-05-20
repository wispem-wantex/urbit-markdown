/-  m=markdown
/+  *test, *markdown
::
::  Leaf nodes
::  ----------
::
|%
  ++  test-heading
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;h1: Asdf
        !>((heading:leaf:sail-en:md [%heading %atx 1 ~[[%text 'Asdf']]]))
      %+  expect-eq
        !>  ^-  manx  ;h4: Asdf
        !>((heading:leaf:sail-en:md [%heading %atx 4 ~[[%text 'Asdf']]]))
      :: With inline elements
      %+  expect-eq
        !>  ^-  manx  ;h1
                        ;code: Asdf
                        ;+  [[%$ [%$ ": A "] ~] ~]
                        ;strong: thingy
                      ==
        !>((heading:leaf:sail-en:md [%heading %atx 1 ~[[%code-span 1 'Asdf'] [%text ': A '] [%strong '*' ~[[%text 'thingy']]]]]))
    ==
  ::
  ++  test-thematic-break
    ;:  weld
      %+  expect-eq
        !>  (break:leaf:sail-en:md [%break '*' 3])
        !>  ^-  manx  ;hr;
    ==
  ::
  ++  test-blank-line
    ;:  weld
      %+  expect-eq
        !>  (blank-line:leaf:sail-en:md [%blank-line ~])
        !>  ^-  manx  [[%$ [%$ " "] ~] ~]
    ==
  ::
  ++  test-codeblk-indent
    ;:  weld
      %+  expect-eq
        !>  ^-  manx  ;code: {"an indented\0a  codeblock\0a"}
        !>((codeblk-indent:leaf:sail-en:md [%indent-codeblock 'an indented\0a  codeblock\0a']))
    ==
  ::
  ++  test-paragraph
    ;:  weld
      %+  expect-eq
        !>  "<p>aaa bbb </p>"
        !>  %-  en-xml:html  %-  paragraph:leaf:sail-en:md
            :-  %paragraph  :~  [%text 'aaa']
                                [%soft-line-break ~]
                                [%text 'bbb']
                                [%soft-line-break ~]
                            ==
      ::
      %+  expect-eq
        !>  "<p>Markdown per se is <em>informally specified</em>; different platforms support slightly different versions. The most complete and widely adopted specification is <a href=\"https://github.github.com/gfm\" title=\"\">the Github spec</a>, <strong>which includes several <em>non-standard</em> extensions of the Markdown format</strong>, while streamlining / removing the syntax in other areas. Our goal with this project is to support the Github &quot;flavor&quot; of Markdown, because many of these extensions are really popular and have effectively become part of the de facto standard. </p>"
        !>  %-  en-xml:html  %-  paragraph:leaf:sail-en:md
            :-  %paragraph  :~  [%text 'Markdown per se is ']
                                [%emphasis '*' ~[[%text 'informally specified']]]
                                [%text '; different platforms support slightly different versions.']
                                [%soft-line-break ~]
                                [%text 'The most complete and widely adopted specification is ']
                                [%link ~[[%text 'the Github spec']] [%direct ['https://github.github.com/gfm' |] ~]]
                                [%text ',']
                                [%soft-line-break ~]
                                :+  %strong  '*'  :~  [%text 'which includes several ']
                                                      [%emphasis '*' ~[[%text 'non-standard']]]
                                                      [%text ' extensions of the Markdown format']
                                                  ==
                                [%text ', while streamlining / removing']
                                [%soft-line-break ~]
                                [%text 'the syntax in other areas. Our goal with this project is to support the Github "flavor" of Markdown,']
                                [%soft-line-break ~]
                                [%text 'because many of these extensions are really popular and have effectively become part of the de facto']
                                [%soft-line-break ~]
                                [%text 'standard.']
                                [%soft-line-break ~]
                            ==
    ==
  ++  test-markdown
    ;:  weld
      %+  expect-eq
        !>  "<html><body><h2>Milestone 1</h2> <p>The first milestone for this project is support for basic, old-school Markdown syntax, but not including the Github flavor&#39;s extensions. </p> <p>Reward: <strong>2 stars</strong> </p> <h2>Milestone 2</h2> <p>TBD, based on any potential challenges encountered in Milestone 1. </p></body></html>"
        !>  %-  en-xml:html  %-  markdown:sail-en:md
            :~  [%heading %atx 2 ~[[%text 'Milestone 1']]]
                [%blank-line ~]
                :-  %paragraph  :~  [%text 'The first milestone for this project is support for basic, old-school Markdown syntax, but not']
                                    [%soft-line-break ~]
                                    [%text 'including the Github flavor\'s extensions.']
                                    [%soft-line-break ~]
                                ==
                [%blank-line ~]
                :-  %paragraph  :~  [%text 'Reward: ']
                                    [%strong '*' ~[[%text '2 stars']]]
                                    [%soft-line-break ~]
                                ==
                [%blank-line ~]
                [%heading %atx 2 ~[[%text 'Milestone 2']]]
                [%blank-line ~]
                :-  %paragraph  ~[[%text 'TBD, based on any potential challenges encountered in Milestone 1.'] [%soft-line-break ~]]
            ==
    ==
--
