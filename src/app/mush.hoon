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
+$  versioned-state  $%(state-0)
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
=|  state-0
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
  ::  ++on-init will set default keys in %settings-store.  It's gross to use
  ::  single-key maps like this but %settings-store doesn't currently support
  ::  sets so we'll roll with it.
  =/  evt=event:settings  [%put-bucket %mush %lineup *(map dog _~)]
  =/  mod=event:settings  [%put-bucket %mush %mode *(map %mode *mode)]
  :_  this
  :~  [%pass / %agent [our.bol %settings-store] %poke !>(evt)]
      [%pass / %agent [our.bol %settings-store] %poke !>(mod)]
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
      ::  Supply a candidate $dog to %settings-store.  The actual current
      ::  $harness is set by a subscription to %settings-store, so we have
      ::  a local practical source and a remote canonical source.
      =/  =dog  +.axn
      =/  rol=(set dogs)  (silt ~(tap by harness))
      =/  rol=(set dogs)  (~(put in rol) dog)
      =/  evt=event:settings  [%put-bucket %mush %lineup (pile:eng rol)]
      :_  this
      :~  [%pass / %agent [our.bol %settings-store] %poke !>(evt)]
      ==
      ::
        %charter
      ::  Set the mode in %settings-store.
      =/  mod=mode  +.axn
      =/  evt=event:settings  [%put-bucket %mush %mode (malt ~[[%mode mod]])]
      :_  this
      :~  [%pass / %agent [our.bol %settings-store] %poke !>(evt)]
      ==
      ::
        %bankrupt
      ::  Remove all info from %settings-store.
      =/  evt=event:settings  [%del-bucket %mush %lineup]
      =/  mod=event:settings  [%del-bucket %mush %mode]
      :_  this
      :~  [%pass / %agent [our.bol %settings-store] %poke !>(evt)]
          [%pass / %agent [our.bol %settings-store] %poke !>(mod)]
      ==      
      ::
        %muster
      ::  Load the candidate $dogs into the $lineup.
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
  ~>  %bout.[0 '%mush +on-agent']
  ^-  (quip card _this)
  `this
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
|_  [bol=bol:gall dek=(list card)]
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
  dat(state !<(state-0 vaz))
::  Load candidate $dogs from %settings-store.
::
++  muster
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-0 vaz))
::  Unroll a set of values into keys for a map of nulls.
::
++  pile
  |=  dogs=(set dog)
  ^-  (map dog _~)
  =/  pups  ~(tap in dogs)
  =/  len   (lent pups)
  =/  idx   0
  =|  pyl=(map dog _~)
  |-
  ?:  =(idx len)  pyl
  $(pyl (~(put by pyl) (snag idx pups)), idx +(idx))
--
