  ::  /app/mush/hoon
::::
::    Support reverse-proxy efforts by load-balancing to a collection of moons.
::
::    %mush is the dispatcher to the %dogs.
::
/-  *mush, settings
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
  :_  this(harness *^harness, lineup *^lineup, mode *^mode, sled *^sled) ::(lineup ~(key by +.dat), mode )
  :~  [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
      [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(mod)]
      [%pass /lineup %agent [our.bol %settings-store] %watch /bucket/mush/lineup]
      [%pass /mode %agent [our.bol %settings-store] %watch /bucket/mush/mode]
  ==
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%mush +on-save']
  !>(state)
::
++  on-load
  |=  ole=vase
  ~>  %bout.[0 '%mush +on-load']
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:eng ole)
  [cards this]
::
++  on-poke
  |=  [mar=mark vaz=vase]
  ^-  (quip card _this)
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
      ::  remote canonical source.
      =/  pup=dog  +.axn
      =/  rol=(set dog)  (~(put in lineup) pup)
      =/  evt=event:settings  [%put-bucket %mush %lineup (pile:eng rol)]
      :_  this(lineup rol)
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
      :~  [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(evt)]
          [%pass / %agent [our.bol %settings-store] %poke %settings-event !>(mod)]
      ==
      ::
        %muster
      ::  Load the candidate $dogs into the $lineup.
      `this
      ::
        %train
      ::  Verify that a possible dog is in fact a valid moon of the team. 
      ::  A valid dog must be a running moon of the current ship.
      `this
      ::
        %hitch
      ::  Load all valid $dogs from the $lineup into the $harness.
      ::  A valid dog must be a running moon of the current ship.
      `this
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
        ~&  >>>  cage
        ~&  >>  wir
        ~&  >  sig
        `this
    ==
      [%mode ~]
  `this
  ==
  :: subscription to %settings-store for dog lineup etc., auto-retirement
::
++  on-arvo
  |=  [wir=wire sig=sign-arvo]
  ~>  %bout.[0 '%mush +on-arvo']
  ^-  (quip card _this)
  `this
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
--
