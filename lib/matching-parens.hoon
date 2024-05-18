::|%
::  ++  palindrome
::    %+  knee  *@  |.  ~+
::    ;~  pose
::      (cook |=(a=@ +(a)) (ifix [(just 'a') (just 'b')] palindrome))
::      (cold 0 (easy ~))
::    ==
::--

|%
  ++  structs
    |%
      +$  document  (list node)
      +$  node  $@  ~
                $%  text
                    parens
                    square
                ==
      +$  text    [%text @t]
      +$  parens  [%parens document]
      +$  square  [%square document]
    --
  ++  de
    |_  [text-no-match=(unit @t)]
      ++  document
        %+  cook  |=(a=document:structs a)
        (star node)
      ++  node
        %+  cook  |=(a=node:structs a)
        ;~  pose
          square
          parens
          text
        ==
      ++  square
        %+  knee  *square:structs  |.  ~+   :: recurse
        %+  cook  |=(a=square:structs a)    :: cast
        %+  stag  %square                   :: tag
        %+  ifix  [sel ser]                 :: delimiters
        %-  star  ;~  pose
          parens
          square
          ~(text . [~ ']'])
        ==
      ++  parens
        %+  knee  *parens:structs  |.  ~+   :: recurse
        %+  cook  |=(a=parens:structs a)    :: cast
        %+  stag  %parens                   :: tag
        %+  ifix  [pal par]                 :: delimiters
        %-  star  ;~  pose
          parens
          square
          ~(text . [~ ')'])
        ==
      ++  text
        %+  cook  |=(a=text:structs ~&("text called" a))
        %+  stag  %text
        %+  cook
          |=  a=tape
          ~&  "tape: {<a>}; match: {<text-no-match>}"
          (crip a)
        %-  plus
        ;~  less   :: text means it doesn't match anything else
          square
          parens
          ?~  text-no-match
            prn
          ;~(less (just u.text-no-match) prn)
        ==
    --
--
