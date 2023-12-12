# Point-to-point (P2P) Diagram
![point-to-point](../images/p2p.png)

This pattern is used when both the producer and the consumer of a message are tightly coupled. The producer is **not** agnostic from its consumer. 

# Pros & Cons of P2P

## Pros

- Easy
- Can help scale applications


## Cons

- Becomes quickly unmanageable at scale as you may lose oversight over how many P2P integrations you have within the global landscape.
- Touching a single app might break others.

# Note

You should minimize the use of P2P integration for inter-application integration. It is however a suitable for solution for intra-application traffic when components of the same application exchange information through a Service Bus or Storage Account queue (see load levelling).