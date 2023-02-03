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

In the current scenario, we would like a request made for a resource to an Urbit
ship to be handled by one of a collection of moons.  Since Urbit validates ships
by `@p` or network address, this requires us to think carefully about how we are
delegating and exposing resources.

We essentially have two choices, given the structure of Ames:

1. Delegate intensive calculation to a subsidiary


We will call a collection of support moons a `%team` consisting of `%dog`s.

This userspace proof-of-concept will allow us to request a dynamic resource from
an Urbit ship's endpoint.  The actual calculation of the dynamic resource will
be delegated to a moon and then served through the parent ship.

Altho not currently an acute problem, load balancing for ships will eventually
need to take place for very active ships on the network (distributing popular
software, for instance, or supporting gameplay).
