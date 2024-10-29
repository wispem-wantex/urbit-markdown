/-  m=markdown
/+  md=markdown, dbug, schooner, server, default-agent
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
    :~  [%pass /eyre/connect %arvo %e %connect [~ /markdown] %renderer]
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
        ?.  ?&  authenticated.req  =(src.bowl our.bowl)  ==
          %-  send  [302 ~ [%login-redirect '/apps/recipe-book']]
        =/  args=(map @t @t)  ?~  body.request.req
                                ~
                              (molt (rash q.u.body.request.req yquy:de-purl:html))
        =/  markdown-data=@t  (fall (~(get by args) 'markdown') '')
        =/  filename       (fall (~(get by args) 'filename') 'untitled')
        =/  parsed-md=(unit markdown:m)  (rush markdown-data markdown:de:md)
        %+  weld
          ^-  (list card)
          ?~  parsed-md
            ~&  "Parsed-md is null"
            ~
          ?~  filename
            ~&  "No filename given"
            ~
          ~&  "Parsed-md is: {<parsed-md>}"
          =/  =task:clay  [%info %my-documents %& [/files/[filename]/md %ins %md !>(`markdown:m`(need parsed-md))]~]
          =/  =note-arvo  [%c task]
          =/  =note:agent:gall       [%arvo note-arvo]
          ~&  "Note: {<note>}"
          :~  [%pass /saved-yay note]  ==
        ^-  (list card)
          %-  send  :+  200  ~  :-  %html  %-  crip  %-  en-xml:html
          =/  style
            '''
            body {
              display: flex;
              align-items: stretch;

              & > * {
                width: 100%
              }
            }
            #composer {
              width: 95%;
              height: 90%;
              display: block;
              outline: 2px solid;
              margin: 1em;
            }
            .rendered-markdown {
              overflow-y: scroll;
              height: 100%;
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
          =/  manx-md=manx  ?~  parsed-md
                              ;h1: Put some markdown on the left and submit it
                            ;div(class "rendered-markdown")
                              ;+  (sail-en:md (need parsed-md))
                            ==
          ;html
            ;head
              ;style: {(trip style)}
            ==
            ;body
              ;div(class "editor")
                ;form(action "/markdown/render", method "POST")
                  ;span
                    ;label: Filename:
                    ;input(type "text", name "filename");
                  ==
                  ;textarea(id "composer", name "markdown", placeholder "Put markdown here"): {(trip markdown-data)}
                  ;input(type "submit", value "Submit");
                ==
              ==
              ;div(class "viewer")
                ;+  manx-md
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
