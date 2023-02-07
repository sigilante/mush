  ::  /app/mush/hoon
::::
::    Support reverse-proxy efforts by load-balancing to a collection of moons.
::
::    %mush is the dispatcher to the %dogs.
::
/-  *mush, settings, ahoy
/+  verb, dbug, default-agent
::
|%
::
+$  versioned-state  $%(state-zero)
::
+$  state-zero
  $:  %zero
      =lineup
      =mode
      =harness
      =sled
      interval=@dr
  ==
::
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-zero
=*  state  -
::
^-  agent:gall
::
=<
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bol)
    eng   ~(. +> [bol ~])
::
++  on-init
  ^-  (quip card _this)
  ::  ++on-init will set default keys in %settings-store.  It's JSON-compatible
  ::  so we can use external services to set the support moons as well.
  =/  evt=event:settings  [%put-bucket %mush %lineup *(map key:settings val:settings)]
  =/  mod=event:settings  [%put-bucket %mush %mode *(map key:settings val:settings)]
  ::=/  dat  .^(data:settings %gx /=settings-store=/bucket/mush/lineup/noun)
  ::=/  mat  .^(data:settings %gx /=settings-store=/bucket/mush/mode/noun)
  :_  this(harness *^harness, lineup *^lineup, mode *^mode, sled *^sled, interval ~s5)
  :~  [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
      [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(mod)]
      [%pass /lineup %agent [our.bol %settings-store] %watch /bucket/mush/lineup]
      [%pass /mode %agent [our.bol %settings-store] %watch /bucket/mush/mode]
      [%pass / %agent [our.bol %ahoy] %poke %ahoy-command !>([%set-update-interval ~s5])]
  ==
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%mush +on-save']
  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state ole)
  ?-  -.old
    %zero  `this(state old)
  ==
::
++  on-poke
  |=  [mar=mark vaz=vase]
  ^-  (quip card _this)
  ~&  >>>  mar
  ~&  >>  vaz
  ?>  =(our src):bol
  ?+    mar  (on-poke:def mar vaz)
      %noun
    (on-poke:def mar vaz)
      %mush-action
    =+  !<(axn=action vaz)
    ?-    -.axn
        %pedigree
      ::  Supply a candidate $dog to $lineup and  %settings-store.  The
      ::  actual current $harness is set by a subscription to
      ::  %settings-store, so we have a local practical source and a
      ::  remote canonical source.  HOWEVER the local state is set when the
      ::  subscribe %fact comes back as a $gift, not here.
      =/  pup=dog  +.axn
      =/  rol=(set dog)  (~(put in lineup) pup)
      =/  evt=event:settings
          [%put-entry %mush %lineup `@tas`(desig +.axn) `val:settings`[%s '']]
      :_  this
      :~  [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
      ==
      ::
        %charter
      ::  Set the mode in %settings-store.
      =/  mod=^mode  +.axn
      ::=/  map=(map key:settings val:settings)  (malt )
      =/  evt=event:settings  [%put-bucket %mush %mode (malt ~[[%mode [%s mod]]])]
      :_  this
      :~  [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
      ==
      ::
        %bankrupt
      ::  Remove all info from %settings-store.
      =/  evt=event:settings  [%del-bucket %mush %lineup]
      =/  mod=event:settings  [%del-bucket %mush %mode]
      :_  this
      :~  [%pass /lineup %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
          [%pass /mode %agent [our.bol %settings-store] %poke %settings-event !>(mod)]
      ==
      ::
        %muster
      ::  Load a collection of candidate $dogs into %settings-store which will
      ::  trigger the $lineup via ++on-agent.
      `this
      ::
        %train
      ::  Verify that a possible dog is in fact a valid moon of the team. 
      ::  A valid dog must be a *running* moon of the current ship.
      =/  mun=dog  +.axn
      ::  Check for rank as moon
      ?>  =(%earl (clan:title mun))
      ::  Check for team membership
      ?>  (team:title our.bol mun)
      ::  Check that the ship is spawned
      ?>  (gth (need .^((unit @ud) j+/(scot %p our.bol)/lyfe/(scot %da now.bol)/(scot %p mun))) 0)
      ::  Check that the ship is running---this will require a %gift to finish
      :_  this
      :~  [%pass /race/(scot %p mun)/(scot %da now.bol) %agent [our.bol %ahoy] %watch /race]
          [%pass /race %agent [our.bol %ahoy] %poke %ahoy-command !>([%add-watch mun interval])]
      ==
      ::
        %hitch
      ::  Load all valid $dogs from the $lineup into the $harness.
      ::  A valid dog must be a running moon of the current ship.
      ::  Since we don't know a priori which dogs are valid, we instead have to
      ::  load every dog and then see if it gets kicked, so we use %train cards.
      |^
        ~&  ~(tap in cards)
        :_  this(harness ~(tap in lineup))
        ^-  (list card)  ~(tap in cards)
      ++  cards
        ^-  (set card)
        %-  ~(run in lineup)
        |=  =dog
        [%pass / %agent [our.bol %mush] %poke %mush-action !>([%train dog])]
      --
      ::
        %ready
      ::  Add a single $dog to the $lineup.
      `this
      ::
        %retire
      ::  Remove a $dog from the $lineup.
      `this
      ::
        %hike
      ::  Add a $dog to the $harness.
      `this
      ::
        %whoa
      ::  Remove a $dog from the $harness.
      `this
      ::
        %voyage
      ::  Register a $run.
      `this
      ::
        %cancel
      ::  Unregister a $run.
      `this
      ::
        %gee
      ::  Delegate a $run.
      `this
      ::
        %haw
      ::  Redirect a $run.
      `this
    ==
  ==
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%mush +on-peek']
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [wir=wire sig=sign:agent:gall]
  ^-  (quip card _this)
  ?+    wir  (on-agent:def wir sig)
      [%lineup ~]
    ?+    -.sig  (on-agent:def wir sig)
        %fact
      ?+    p.cage.sig  (on-agent:def wir sig)
          %mush-action
        =/  axn  !<(action q.cage.sig)
        ~&  >  axn
        `this
        ::
        ::  Handle incoming changes from %settings-store
        ::
          %settings-event
        =/  evt  !<(event:settings q.cage.sig)
        ?+    -.evt  (on-agent:def wir sig)
            %put-entry
          `this(lineup (~(put in lineup) (resig key.evt)))
          ::
            %del-entry
          `this(lineup (~(del in lineup) (resig key.evt)))
          ::
            %del-bucket  ::TODO doesn't work yet & needs to do more
          `this(lineup *^lineup, harness *^harness)
        ==  :: settings-event
      ==  :: mark
    ==  :: wire type
      [%mode ~]
  `this
      [%race *]
    ?+    -.sig  (on-agent:def wir sig)
        %fact
      ?+    p.cage.sig  (on-agent:def wir sig)
        ::
        ::  Handle incoming changes from %ahoy
        ::
          %ahoy-status
        =/  sta  !<(status:ahoy q.cage.sig)
        ?-    -.sta
            %down
          ?~  (find ~[`dog`+.sta] harness)
            `this
          `this(harness (oust [(need (find ~[`dog`+.sta] harness)) 1] harness))
          ::
            %up
          ?~  (find ~[`dog`+.sta] harness)
            `this(harness (weld harness ~[`dog`+.sta]))
          `this
        ==  :: ahoy-status
      ==  :: mark
    ==  :: wire type
  ==  :: wire
  :: subscription to %settings-store for dog lineup etc., auto-retirement
::
++  on-arvo
  |=  [wir=wire sig=sign-arvo]
  ~>  %bout.[0 '%mush +on-arvo']
  ^-  (quip card _this)
  (on-arvo:def wir sig)
  ::?+    wir  (on-agent:def wir sig)
    ::  %race
    :: /race checks whether a moon is running, so we only care if it is
    ::?+    sig  (on-agent:def wir sig)
    ::    [%khan arow *]
     :: (on-agent:def wir sig) ::`this
    ::==  :: sign
  ::==  :: wire
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%mush +on-watch']
  ^-  (quip card _this)
  `this
::
++  on-fail
  ~>  %bout.[0 '%mush +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%mush +on-leave']
  on-leave:def
--
|_  [bol=bowl:gall dek=(list card)]
+*  dat  .
++  emit  |=(=card dat(dek [card dek]))
++  emil  |=(lac=(list card) dat(dek (welp lac dek)))
++  abet
  ^-  (quip card _state)
  [(flop dek) state]
::
++  init
  ^+  dat
  dat
::
++  load
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-zero vaz))
::  Load candidate $dogs from %settings-store.
::
++  muster
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-zero vaz))
::  Unroll a set of values into keys for a map of nulls.
::
++  pile
  |=  dogs=(set dog)
  ^-  (map key:settings val:settings)
  =/  pups  ~(tap in dogs)
  =/  len   (lent pups)
  =/  idx   0
  =|  pyl=(map key:settings val:settings)
  |-
  ?:  =(idx len)  pyl
  %=  $
    pyl  (~(put by pyl) `key:settings`(desig (snag idx pups)) `val:settings`[%s ''])
    idx  +(idx)
  ==
::  Trim the leading ~ sig off of a @p as a cord and return it as a term.
::
++  desig
  |=  =@p
  ^-  @tas
  (crip +:(trip (scot %p p)))
::  Add a leading ~ sig to a cord and return as a @p.
::
++  resig
  |=  =@tas
  ^-  @p
  (need (slaw %p (crip `tape`(weld "~" (trip tas)))))
--
