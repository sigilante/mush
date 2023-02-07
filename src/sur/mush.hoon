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
::  $lineup: the root collection of whitelisted moons, whether available or no
+$  lineup    (set dog)
::  $harness: a collection of moons to support operations (drawn from $lineup)
::    a $harness is a list because it has an order for round-robin assignment
+$  harness   (list dog)
::  $sled: tracker for tasks delegated to moons
+$  sled      (map run dog)
::  $mode: how the task delegation should be handled
+$  mode      ?(%delegate %redirect)
::  $run: an endpoint for the support $dog to handle
+$  run       path
::  $action: the basic events for the %mush app logic
+$  action
  $%  :: %pedigree adds a candidate $dog to %settings-store
      [%pedigree =dog]
      :: %charter sets the mode in %settings-store
      [%charter =mode]
      :: %bankrupt clears all related data from %settings-store
      [%bankrupt ~]
      :: %muster loads a collection of moons, including validation
      [%muster ~]
      :: %train ensures that a possible $dog is in fact a moon of the team
      [%train =dog]
      :: %muster loads a collection of moons, including validation
      [%hitch ~]
      :: %ready adds a $dog to the $lineup
      [%ready =dog]
      :: %retire removes a $dog from the $lineup
      [%retire =dog]
      :: %hike adds a $dog to the $harness
      [%hike =dog]
      :: %whoa retires a $dog from the $harness
      [%whoa =dog]
      :: %voyage registers a $run, or endpoint.
      [%voyage =run]
      :: %cancel unregisters a $run, or endpoint.
      [%cancel =run]
      :: %gee delegates a $run to the given $dog
      [%gee =dog =run]
      :: %haw redirects a $run to the given $dog
      [%haw =dog =run =ship]
  ==
--
