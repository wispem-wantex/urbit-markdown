# Markdown on Urbit

This is a Markdown implementation on Urbit.  It's more complete than Udon and supports Github-extended markdown syntax including tables, strikethru, task lists, reference links, nested list types, and embedded HTML.

This library includes:

- a bespoke `markdown` data structure, in `/sur/markdown.hoon`
- a parser, which converts markdown text to `markdown` objects
- an HTML renderer, which converts `markdown` objects to HTML

## Data structure

`/sur/markdown.hoon` is a core with a `markdown` arm:

```hoon
::
::  Markdown document or fragment: a list of nodes
++  markdown  =<  $+  markdown
                  (list node)
              |%
                +$  node  $+  markdown-node
                          $@  ~                   :: `$@  ~` is magic that makes recursive structures work
                          $%  [%leaf node:leaf]
                              [%container node:container]
                          ==
              --
:: ...
```

- A `markdown` object is a `(list node)`.
- `node`s are block-level elements, which can be either
  - container nodes (ordered/unordered lists or block-quotes), or
  - leaf nodes (everything else).
- Container nodes have more nodes inside them (either leaf or container).
- Leaf nodes contain inline elements like text, links, or code spans.
- Some inline elements can contain other inline elements, like emphasis or links.  Others are terminal (contain no further nested content).

#### Example

Consider the following markdown text:

```markdown
# Example 1

Some text.  *Italic text* and **bold text**.  `Code!`
```

This will parse to:

```hoon
~[
  [%leaf [%heading style=%atx level=1 contents=~[[%text text='Example 1']]]]
  [%leaf [%blank-line ~]]
  [ %leaf
    [ %paragraph
        contents
      ~[
        [%text text='Some text.  ']
        [%emphasis emphasis-char='*' contents=[i=[%text text='Italic text'] t=~]]
        [%text text=' and ']
        [%strong emphasis-char='*' contents=[i=[%text text='bold text'] t=~]]
        [%text text='.  ']
        [%code-span num-backticks=1 text='Code!']
        [%soft-line-break ~]
      ]
    ]
  ]
]
```

There are 3 leaf nodes: a `%heading`, a `%blank-line`, and a `%paragraph`.
- The heading has the contents `[%text 'Example 1']`.
- Blank lines have no content (they are blank).
- The paragraph has a series of text elements, some of which are formatted with `%emphasis` and `%strong`, and a `%code-span`.
  - `%emphasis` and `%strong` each have their own contents-- in this case, just one `%text` element each.
  - `%code-span` is a flat element that can only contain unformatted text.

That `markdown` object will render into the following HTML:

```html
<div>
  <h1>Example 1</h1>
  <p>Some text.  <em>Italic text</em> and <strong>bold text</strong>.  <code>Code!</code> </p>
</div>
```

## Usage

The `/lib/markdown.hoon` file is a core with 3 arms: `de`, `en`, and `sail-en`.  `de` parses markdown text into a `markdown` object.  `en` serializes a `markdown` object into markdown text again.  `sail-en` converts a `markdown` object into a Sail object (manx) for rendering as HTML.

```hoon
::  This is how I like to do the imports.
/-  m=markdown
/+  md=markdown
::
::  Some sample markdown text ('\0a' is a newline)
=/  markdown-text  '# Example 1\0a\0aSome text.  *Italic text* and **bold text**.  `Code!`'
::
::  These are equivalent: invoke parser directly, vs using convenience method
=/  parsed-md=(unit markdown:m)   (de:md markdown-text)       :: Shortcut
=/  parsed-md2=(unit markdown:m)  (rush markdown-text markdown:de:md)  :: Invoking parser directly
::
::  Both return `(unit markdown)` (empty if parsing fails)
?~  parsed-md  !!  :: check for failure
::
::  Convert to a Sail object
=/  unrendered-html=manx  (sail-en:md u.parsed-md)
::
::  Print as HTML
=/  rendered-html=tape  (en-xml:html unrendered-html)
rendered-html
```
