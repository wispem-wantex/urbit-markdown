/-  m=markdown
/+  markdown, dbug, schooner, server, default-agent
::
/*  styles-css  %css  /app/static/styles/css
::
=/  md  md:markdown
::
|%
  +$  card  card:agent:gall
  +$  state
    $%  %0
    ==
--
::
%-  agent:dbug
::
=|  state
=*  state  -
::
^-  agent:gall
|_  =bowl:gall
  +*  this  .
      default   ~(. (default-agent this) bowl)
  ::
  ++  on-init
    ^-  (quip card _this)
    :_  this
    :~  [%pass /eyre/connect %arvo %e %connect [~ /blog] %blog]
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    :_  this :: We have no state
    ?+  mark  ~|  "unexpected poke to {<dap.bowl>} with mark {<mark>}"  !!
      %handle-http-request
        =/  [eyre-id=@ta req=inbound-request:eyre]  !<([@ta =inbound-request:eyre] vase)
        =/  send           (cury response:schooner eyre-id)
        =/  [[ext=(unit @ta) site=path] args=(list [key=@t val=@t])]  (parse-request-line:server url.request.req)
        =/  style
          '''
          body {
            margin: 3em 20%;
          }

          .index-page {
            .posts-list {
              list-style: none;

              a {
                text-decoration: none;
              }
            }
            .post-preview {
              display: flex
            }
          }

          /** Make it easier to see some formatting stuff **/
          blockquote {
            border-left: 3px solid gray;
            padding-left: 1em;
          }
          :not(pre) > code {
            background-color: #eee;
            padding: 0.2em 0.3em;
            border-radius: 0.2em;
          }
          pre {
            background-color: #eee;
            display: inline-block;
            padding: 0.5em 1em;
            border-radius: 0.3em;
            border: 1px solid #aaa;
          }

          ul.task-list {
            padding-left: 1em;
            list-style: none;

            & li > input[type="checkbox"] {
              float: left;
              margin: 0.2em 1em;
            }
          }

          table {
            border-collapse: collapse;
            /* border: 1px solid #333; */
            border-radius: 0.3em;

            th, td {
              border: 1px solid #aaa;
              padding: 0.5em 1em;
            }
          }
          '''
        ::
        ?+  site  (send [404 ~ [%stock ~]])
          [%blog %static *]
          %-  send
          ?+  (slag 2 `(list @ta)`site)  [404 ~ [%stock ~]]
              [%styles %css ~]
            [200 ~ [%css styles-css]]
          ==
          ::
          [%blog ~]
            :: Index page
            =/  posts-list=(list path)  .^((list path) %ct `path`/(scot %p our.bowl)/my-documents/(scot %da now.bowl)/files)
            =/  make-post-preview
              |=  [post-path=path]
              ^-  manx
              =/  post=markdown:m  .^(markdown:m %cx (weld /(scot %p our.bowl)/my-documents/(scot %da now.bowl) post-path))
              =/  =cass:clay  .^(cass:clay %cw (weld /(scot %p our.bowl)/my-documents/(scot %da now.bowl) post-path))
              =/  title=tape  (trip (head (slag 1 post-path)))
              =/  thumbnail-url=(unit @t)  (get-preview-img:md post)
              ;a(href "/blog/{title}")
                ;li(class "post-preview")
                  ;img(class "preview__thumbnail", src (trip (fall thumbnail-url '')));
                  ;span(class "preview__description")
                    ;div(class "preview__title"): {title}
                    ;div(class "preview__date"): {(scow %da da.cass)}
                  ==
                ==
              ==
            %-  send  :+  200  ~  :-  %html  %-  crip  %-  en-xml:html
            ;html
              ;head
                ;link(rel "stylesheet", href "/blog/static/styles/css");
                ::;style: {(trip style)}
              ==
              ;body(class "index-page")
                ;h1: Posts
                ;ul(class "posts-list")
                  ;*  %+  turn  posts-list  make-post-preview
                ==
              ==
            ==
          ::
          [%blog @ ~]
            :: Post page
            =/  post-title=@ta  (snag 1 `(list @ta)`site)
            =/  post=markdown:m  .^(markdown:m %cx /(scot %p our.bowl)/my-documents/(scot %da now.bowl)/files/[post-title]/md)
            =/  rendered-post=manx  (sail-en:markdown post)
            %-  send  :+  200  ~  :-  %html  %-  crip  %-  en-xml:html
            ;html
              ;head
                ;link(rel "stylesheet", href "/blog/static/styles/css");
                ::;style: {(trip style)}
              ==
              ;body
                ;ul(class "headings-list")
                  ;*  %+  turn  (get-headers:md post)
                      |=  [lvl=@ text=tape]
                      ;li(style "padding-left: {<lvl>}em;")
                        ; {text}
                      ==
                ==
                ;+  rendered-post
              ==
            ==
        ==
    ==
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    :_  this  :: We don't have any state
    ?+  sign-arvo  (on-arvo:default wire sign-arvo)
      ::
      :: Arvo will respond when we initially connect to Eyre in `on-init`.  We will accept (and ignore)
      :: that and reject any other communications.
        [%eyre %bound *]
      ~&  "Got eyre bound: {<sign-arvo>}"
      ~
      ::
        [%clay *]
      ~&  "Got clay message: {<sign-arvo>}"
      ~  :: Ignore it
    ==
  ::
  :: Each time Eyre pokes a request to us, it will subscribe for the response.  We will just accept
  :: those connections (wire = /http-response/[eyre-id]) and reject any others.
  :: See: https://docs.urbit.org/system/kernel/eyre/reference/tasks#connect
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:default path)
        [%http-response *]
      `this
    ==
  ::
  ++  on-save   on-save:default
  ++  on-load   on-load:default
  ++  on-leave  on-leave:default
  ++  on-peek   on-peek:default
  ++  on-agent  on-agent:default
  ++  on-fail   on-fail:default
--
