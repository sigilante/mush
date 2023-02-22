  ::  agent wrapper for %mush load balancing and CDN
::::
::    usage: %-(agent:mush your-agent)
::
::    This agent wrapper needs to handle pokes, peeks, and agent subscriptions.
::
|%
+$  poke
  $%  [%bowl ~]
      [%state grab=cord]
      [%incoming =about]
      [%outgoing =about]
  ==
::
+$  about
  $@  ~
  $%  [%ship =ship]
      [%path =path]
      [%wire =wire]
      [%term =term]
  ==
::
++  agent
  |=  =agent:gall
  ^-  agent:gall
  !.
  |_  =bowl:gall
  +*  this  .
      ag    ~(. agent bowl)
  ::
  ::  Poke handling involves redirecting endpoints to %mush.
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=(%mush-effect mark)
      :: this is muddled because it shouldn't pass first, it should pass instead
      =^  cards  agent  (on-poke:ag mark vase)
      =/  idx  0
      =/  carts=_cards  ~
      |-  ^-  (quip card:agent:gall agent:gall)
      ?:  =(idx (lent cards))  [cards this]
      =/  cart  [%pass / %agent [our.bol %mush] %poke %mush-card !>((snag idx cards))]
      $(idx +(idx), carts (weld cart carts))
    =/  dbug
      !<(poke vase)
    =;  =tang
      ((%*(. slog pri 1) tang) [~ this])
    ?-  -.dbug
      %bowl   [(sell !>(bowl))]~
    ::
        %state
      =?  grab.dbug  =('' grab.dbug)  '-'
      =;  product=^vase
        [(sell product)]~
      =/  state=^vase
        ::  if the underlying app has implemented a /dbug/state scry endpoint,
        ::  use that vase in place of +on-save's.
        ::
        =/  result=(each ^vase tang)
          (mule |.(q:(need (need (on-peek:ag /x/dbug/state)))))
        ?:(?=(%& -.result) p.result on-save:ag)
      %+  slap
        (slop state !>([bowl=bowl ..zuse]))
      (ream grab.dbug)
    ::
        %incoming
      =;  =tang
        ?^  tang  tang
        [%leaf "no matching subscriptions"]~
      %+  murn
        %+  sort  ~(tap by sup.bowl)
        |=  [[* a=[=ship =path]] [* b=[=ship =path]]]
        (aor [path ship]:a [path ship]:b)
      |=  [=duct [=ship =path]]
      ^-  (unit tank)
      =;  relevant=?
        ?.  relevant  ~
        `>[path=path from=ship duct=duct]<
      ?:  ?=(~ about.dbug)  &
      ?-  -.about.dbug
        %ship  =(ship ship.about.dbug)
        %path  ?=(^ (find path.about.dbug path))
        %wire  %+  lien  duct
               |=(=wire ?=(^ (find wire.about.dbug wire)))
        %term  !!
      ==
    ::
        %outgoing
      =;  =tang
        ?^  tang  tang
        [%leaf "no matching subscriptions"]~
      %+  murn
        %+  sort  ~(tap by wex.bowl)
        |=  [[[a=wire *] *] [[b=wire *] *]]
        (aor a b)
      |=  [[=wire =ship =term] [acked=? =path]]
      ^-  (unit tank)
      =;  relevant=?
        ?.  relevant  ~
        `>[wire=wire agnt=[ship term] path=path ackd=acked]<
      ?:  ?=(~ about.dbug)  &
      ?-  -.about.dbug
        %ship  =(ship ship.about.dbug)
        %path  ?=(^ (find path.about.dbug path))
        %wire  ?=(^ (find wire.about.dbug wire))
        %term  =(term term.about.dbug)
      ==
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?.  ?=([@ %mush *] path)
      (on-peek:ag path)
    ?+  path  [~ ~]
      [%u %mush ~]                 ``noun+!>(&)
      [%x %mush %state ~]          ``noun+!>(on-save:ag)
      [%x %mush %subscriptions ~]  ``noun+!>([wex sup]:bowl)
    ==
  ::
  ++  on-init
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  on-init:ag
    [cards this]
  ::
  ++  on-save   on-save:ag
  ::
  ++  on-load
    |=  old-state=vase
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-load:ag old-state)
    [cards this]
  ::
  ::  Subscription handling involves redirecting endpoints to %mush.
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-watch:ag path)
    ~&  >  cards
    =/  idx  0
    =/  carts=_cards  ~
    |-  ^-  (quip card:agent:gall agent:gall)
    ?:  =(idx (lent cards))  [cards this]
    =/  cart  (snag idx cards)
    $(idx +(idx), carts (weld cart carts))
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-agent:ag wire sign)
    [cards this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-arvo:ag wire sign-arvo)
    [cards this]
  ::
  ++  on-fail
    |=  [=term =tang]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
--
