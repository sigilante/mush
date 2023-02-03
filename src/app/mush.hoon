  ::  /app/mush/hoon
::::
::    Support reverse-proxy efforts by load-balancing to a collection of moons.
::
::    %mush is the dispatcher to the %dogs.
::
/-  mush
/+  verb, dbug, default-agent
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-zero
  $:  %zero
      =harness:mush
      =lineup:mush
      =sled:mush
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
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    eng   ~(. +> [bowl ~])
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%mush +on-init']
  =^  cards  state
    abet:init:eng
  [cards this]
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
  ~>  %bout.[0 '%mush +on-poke']
  ^-  (quip card _this)
  `this
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
  dat(state !<(state-0 vaz))
--
