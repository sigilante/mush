  ::  /sur/mush/hoon
::::
::    Support reverse-proxy efforts by load-balancing to a collection of moons.
::
|%
+|  %molds
::  $dog: a moon to support an operation
+$  dog       @p
::  $ship: any caller
+$  ship      @p
::  $harness: a collection of moons to support operations (drawn from $lineup)
::    a $harness is a list because it has an order for round-robin assignment
+$  harness   (list dog)
::  $lineup: the root collection of whitelisted moons, whether available or no
+$  lineup    (set dog)
::  $sled: tracker for tasks delegated to moons
+$  sled      (map run dog)
::  $run: an endpoint for the support $dog to handle
+$  run       path
::  $action: the basic events for the %mush app logic
+$  action
  $%  :: %train ensures that a possible $dog is in fact a moon of the team
      [%train =dog]
      :: %ready adds a $dog to the $line
      [%ready =dog]
      :: %retire removes a $dog from the $harness
      [%retire =dog]
      :: %hike adds a $dog to the $harness
      [%hike =dog]
      :: %whoa retires a $dog from the $harness
      [%whoa =dog]
      :: %gee delegates a $run to the given $dog
      [%gee =dog =run]
      :: %haw redirects a $run to the given $dog
      [%haw =dog =run =ship]
  ==
--
