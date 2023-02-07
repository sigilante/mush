::  ahoy: ship monitoring
::
::  ~midden-fabler wrote the original of this, but this is not his version.
::  This version has been nerfed a bit since it's just for one app to use.
::
::    get notified if last-contact with a ship
::    exceeds a specified amount of time
::
::  scrys:
::    .^((map @p @dr) %gx /=ahoy=/watchlist/noun)
::    .^((set ship) %gx /=ahoy=/watchlist/ships/noun)
::    .^(@dr %gx /=ahoy=/update-interval/noun)
::
/-  *ahoy
/+  default-agent,
    agentio,
    dbug,
    ahoy
::
=>  |%
    +$  card  card:agent:gall
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0  [%0 records]
    --
::
=|  state-0
=*  state  -
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
    io    ~(. agentio bowl)
    pass  pass:io
::
++  on-init
  ^-  (quip card _this)
  =/  interval=@dr  ~m5
  =+  sponsor=(sein:title [our now our]:bowl)
  :_  this(update-interval interval)
  :~  (poke-self:pass %ahoy-command !>([%add-watch sponsor ~d1]))
      (set-timer interval)
  ==
::
++  on-save  !>(state)
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state ole)
  ?-  -.old
    %0  [~ this(state old)]
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our src):bowl
  ?+    mark  (on-poke:def mark vase)
      %noun
    =+  !<(who=ship vase)
    :_  this
    [(send-plea:hc who)]~
  ::
      %ahoy-command
    =+  !<(cmd=command vase)
    ?-    -.cmd
        %add-watch
      :: this version allows to watch ships that haven't been launched yet
      :-  [(send-plea:hc ship.cmd)]~
      this(watchlist (~(put by watchlist) ship.cmd t.cmd))
    ::
        %del-watch
      `this(watchlist (~(del by watchlist) ship.cmd))
    ::
        %set-update-interval
      `this(update-interval t.cmd)
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%race *]
    ?>  =(our src):bowl
    `this
  ==  :: path
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%ahoy @ ~]  [~ this]
  ::
      [%update-interval ~]
    =^  cards  state
      on-update-interval:hc
    [cards this]
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  =(our src):bowl
  ?+  path  (on-peek:def path)
    [%x %watchlist ~]         ``noun+!>(watchlist)
    [%x %watchlist %ships ~]  ``noun+!>(~(key by watchlist))
    [%x %update-interval ~]   ``noun+!>(update-interval)
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
::
=|  cards=(list card)
|_  =bowl:gall
++  this  .
++  abet
  ^-  (quip card _state)
  [(flop cards) state]
::
++  emit
  |=  car=card
  this(cards [car cards])
::
++  emil
  |=  rac=(list card)
  |-  ^+  this
  ?~  rac
    this
  =.  cards  [i.rac cards]
  $(rac t.rac)
::
++  on-update-interval
  ^-  (quip card _state)
  ::  reset timer
  =.  this  (emit (set-timer update-interval))
  ::  send pleas
  =.  this
    %-  emil
    %+  turn  ~(tap in ~(key by watchlist))
    |=  [who=ship]
    (send-plea who)
  ::  send notifications
  =.  this
    %-  emil
    %-  zing
    %+  turn  ~(tap in down-status)
    |=  [who=ship]
    :: TODO just pass back to subscribers instead
    [%give %fact ~[/race] %ahoy-status !>([%down who])]~
  abet
::
++  set-timer
  |=  t=@dr
  ^-  card
  =/  when=@da  (add now.bowl t)
  [%pass /update-interval %arvo %b %wait when]
::
++  send-plea
  |=  [who=ship]
  ^-  card
  [%pass /ahoy/(scot %p who) %arvo %a %plea who %evil-vane / ~]
::
++  down-status
  ^-  (set ship)
  %-  silt
  %+  murn  ~(tap in ~(key by watchlist))
  |=  [who=ship]
  =/  when=(unit @dr)  (~(last-contact ahoy bowl) who)
  ?~  when  ~
  ?.  (gte u.when (~(got by watchlist) who))
    ~
  `who
::
--
