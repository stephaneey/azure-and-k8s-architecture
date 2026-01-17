# Resilience 

Azure has many different ways to replicate data and/or handle multi-region architectures. The purpose of this cheat sheet is to highlight how to tackle resilience with the mostly used Azure services.

For each service, I'm considering two situations:

- when both regions are up and running
- when the primary region is *totally* out

I'm also considering isolation from Internet for all the use cases as it is most representative of entreprise-grade architectures. If you test this in your own environment, it is likely that the primary region will not be out, so you might think the system behaves differently but it doesn't.

**Azure SQL**

In the diagram, I show how both geo-replication and failover groups compare. Note that my preference goes to failover groups because they handle DNS gracefully thanks to the static listener endpoints. Additionally, you may decide to failover one or more databases at the same time as opposed to geo-replication.

**Cosmos DB single vs multi-region writes**

Cosmos DB is great for multi-region scenarios as it supports multi-region writes. Additionally, related SDKs seamlessly switch to the available region(s) without any effort from the development side. Still, I represent both, single write/read-only replica and multi-region writes.


**Azure Storage**

I have illustrated different use cases such as Azure Storage used in hero-regions (e.g. West Europe/North Europe), restricted regions (e.g. France Central) and local regions (e.g. Belgium Central). These are situations that can lead to headaches.

**Event Hubs and Service Bus**
Next, I show how both Event Hubs and Service Bus deal with geo-replication and geo-disaster recovery. These are related but very different implementations.

**API Management**
Last, I finish with a first-class citizen in any Azure architecture, namely API Management. I explore a possible setup with APIM Premium v2, which as of 01/2026 doesn't support private endpoints yet and consequently, cannot be directly behind Azure Front Door when not internet-facing.

![resilience](./images/resilience.png)