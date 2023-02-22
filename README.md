#   `%mush`
##  A Ship-Based Reverse Proxy for Urbit

A reverse proxy dispatches incoming service commands to a single endpoint
across multiple backend resources to help scalability, resilience, and
performance.

This can be useful for a couple of reasons in an Urbit system:

1. Application dispatch reflecting a locally hosted app through Iris and Eyre.
2. Content distribution network implementation.

`%mush` is a proof-of-concept for a content distribution network (CDN) built
on Urbit.  The idea behind a content distribution network is to let a request
for a particular resource be handled by one of many back-end servers.  Popular
websites rely on CDNs since each server can handle only a limited number of
client sessions at a given time.  By redirecting a request for a particular
service made to a central endpoint according to some algorithm (round-robin, for
instance), the service can be made robust and scalable.

For instance, imagine a popular Urbit-hosted resource such as an image server.
The image resource requested at a particular endpoint on the ship should be
returned as a noun over Ames to the caller.  However, perhaps the ship is only
intermittently available, or is so burdened by requests that a new marginal
request degrades performance.  It would be preferable for the endpoint to be
able to serve the resource efficiently by cycling or load-balancing a set of
support ships.

In the current scenario, we would like a request made for a resource to an Urbit
ship to be handled by one of a collection of moons.  Since Urbit validates ships
by `@p` or network address, this requires us to think carefully about how we are
delegating and exposing resources.  Ames won't be fooled the same way one can
set up a reverse proxy by hiding the origin server, leaving us essentially two
choices:

1.  **Delegation**.  Delegate intensive calculation to a subsidiary ship and
    then serve the result through the original callee.  This is structurally
    simple but may not solve the root issue of scalability for many scenarios.
    This is similar to a classic CDN in that it maintains a single URI for
    access.
2.  **Redirection**.  Redirect single service calls explicitly to the
    delegated support moon, which then treats directly as the service provider.
    This should require the caller to always go back to the main switch for each
    call in order to preserve load balancing.

`%mush` is built to delegate, meaning that the original callee ship will serve
the result to the caller.  Redirection is left as an exercise to the reader.


##  User Story

Let's suppose that we have a `%mush`-compatible agent `%mirage` which simply
provides image data from an endpoint.  That's all it is, an image host.  By
itself, `%mirage` can simply serve images through peeks until the end of its
days.  However, suppose that `%mirage` does something more interesting and
computationally intensive:  it resizes images, which means a dynamic operation
has to take place.  This creates more load on the instance, and in the limit
could mean system delays.

One solution is to use a CDN like `%mush`.  What `%mush` will do for `%mirage`
is maintain a stable of moons running `%mirage` or clients which can themselves
do the calculations.  Any call to `%mirage` will be routed to an appropriate
moon, and then either returned directly as if from `%mirage` (delegation) or
returned from the instance of `%mirage` on that moon (redirection).

From the caller side, a call to `%mirage` should look like a regular call to any
endpoint:

1. Poke for data to `%mirage` on ~sampel-palnet.
2. Subscribe for result to `%mirage` at ~sampel-palnet.

That is, `%mush` should be invisible to the caller.  The question is what this
additional infrastructure looks like for `%mirage`'s developers.

Ideally, using `%mush` should only require including the `%mush` agent and a
single drop-in line, much as `%dbug`.  The complexity here is that a library
cannot know about agent state, but it can punt calls via the `%mush` agent.

The `%mush` agent will need to be provisioned explicitly, with moons running the
delegating agent (e.g. `%mirage`).  This needs to be done manually at the
current time since moons cannot be launched autonomously.


##  Code

`%mush` will employ a [sled dog
metaphor](https://www.neewadogs.com/blogs/blog/sled-dog-commands).  The entry
point dispatcher is `%mush`, which will hand off `$run`s to the `$dog`s on the
`$harness`.

We will call a collection of support moons a `$harness` consisting of `$dog`s,
and we will assign tasks to them based on a round-robin algorithm.  `%mush`
will support both delegation (`%gee`) and redirection (`%haw`).  There is a
master list of `$dog`s called a `$lineup` from which the `$harness` of actually
running `$dog`s is drawn.  Each incoming `$run` is assigned to a `$dog` by the
specified `$mode`.

The pokes include:

- `%pedigree` to add a candidate `$dog` to `%settings-store`.  (Ultimately
    we'll want this from a file.)
- `%charter` to set the mode in `%settings-store`, as one of `%delegate`
    (`%gee`) or (`%redirect`) `%haw`.
- `%bankrupt` to remove all related data from `%settings-store`.
- `%muster` to load the candidate `$dog`s from `%settings-store`, key
   `%mush %lineup` (with validation).
-  `%train` ensures that a possible `$dog` is in fact a moon of the team (no
    check against `lineup` is made, simply that the point is a running moon).
- `%hitch` loads all valid `$dog`s from the `$lineup` into the `$harness`.  A
    valid `$dog` is a running moon of the current ship.
- `%ready` adds a `$dog` to the `$lineup` (with validation).
- `%retire` removes a `$dog` from the `$lineup`.
- `%hike` adds a `$dog` to the `$harness` (with verification).
- `%whoa` retires a `$dog` from the `$harness`.
- `%gee` delegates a `$run`, or endpoint task, to the given `$dog`.  The mode
    is set from `%settings-store`, key `%mush %mode`.
- `%haw` redirects a `$run`, or endpoint task, to the given `$dog`.  This mode
    is not active in the current version of `%mush`, as it needs the caller to
    track the result from the new subsidiary source.

The major data structures in the state include:

- `lineup` maintains a list of candidate moons which may be available for use
    with this app.  The moons are initially loaded from `%settings-store`,
    and an agent-local copy is maintained.  A subscription to `%settings-store`
    is maintained so that regular JSON-based external interactions can alter
    the moon list.  `lineup` is a `set` because order does not matter.

- `mode` determines whether delegation or redirection is preferred.  Delegation,
    as mentioned above, lets the client moon carry out the endpoint task, while
    redirection actually tells the caller to instead request from the moon
    directly at the same endpoint.

- `harness` represents the list of moons which are actually available for use
    as support clients.  This list needs to be actively maintained against the
    known state of spawned and running moons as well as the `lineup`.  `harness`
    is a `list` because a round-robin algorithm is used to balance the load.

- `sled` tracks the `run`s assigned to `dog`s, or in other words who is
    responsible for what in this system.  We don't maintain a separate queue of
    calls since that's really what Urbit does for us—the advantage of an event
    log.

- `run` represents the target Gall agent and the intended endpoint, e.g.
    `/groups/`.  Incoming data is handled as a `cage`.

Ideally, `%mush` compatibility will be able to work like `%dbug` as an agent
wrapper.  A complying agent will be able to automatically handle `%mush` CDN
behavior by including a single line such as `%-  agent:mush`.

Altho not currently an acute problem, load balancing for ships will eventually
need to take place for very active ships on the network (distributing popular
software, for instance, or supporting gameplay).

TODO:
- [ ] deduplicate subscriptions to `%ahoy` per moon
- [ ] try with `|install` triggers or `%docket` discovery stuff


##  Challenges

- How can `%mush` be modified to handle redirects as well (`%gee`)?
- Should moons be partitioned by resource served, rather than simply
    round-robin?


##  Further Reading

- [`%dbug` Debugging Wrapper](https://developers.urbit.org/guides/additional/app-workbook/dbug), Urbit App Workbook

---

##  Some Useful Commands

```hoon
:mush &mush-action [%pedigree ~dister-dozzod-doznec]
:mush &mush-action [%pedigree ~mister-dozzod-doznec]
:mush &mush-action [%pedigree ~mistyr-dozzod-doznec]
:mush &mush-action [%train ~dister-dozzod-doznec]
:mush &mush-action [%train ~mister-dozzod-doznec]
:mush &mush-action [%train ~mistyr-dozzod-doznec]
:mush &mush-action [%hitch ~]

:mush &mush-action [%bankrupt ~]
```

Useful training moons:

```hoon
~dister-dozzod-doznec
~distyr-dozzod-doznec
~mister-dozzod-doznec
~mistyr-dozzod-doznec
```
