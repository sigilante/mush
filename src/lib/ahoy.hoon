|_  =bowl:gall
++  ship-state
  |=  [who=ship]
  ^-  (unit ship-state:ames)
  ?.  (~(has in peers) who)
    ~
  `.^(ship-state:ames %ax /(scot %p our.bowl)//(scot %da now.bowl)/peers/(scot %p who))
::
++  peers
  ^-  (set ship)
  =/  mips
    .^((map ship ?(%alien %known)) %ax /(scot %p our.bowl)//(scot %da now.bowl)/peers)
  ~(key by mips)
::
++  last-contact
  |=  [who=ship]
  ^-  (unit @dr)
  =/  ss=(unit ship-state:ames)  (ship-state who)
  ?~  ss  ~
  ?.  ?=([%known *] u.ss)
    ~
  =/  last-contact=@da  last-contact.qos.u.ss
  =/  when=@dr  (sub now.bowl last-contact)
  `when
--
