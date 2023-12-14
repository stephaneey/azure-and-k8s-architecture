# East-West Traffic for AKS variants
What we have seen in the other pages on this topic are the most frequent ways of working with AKS. However, there are edge cases or edge companies who deviate from the norm. Below are a few examples.
## Dedicated cluster per application

This is an extreme approach which consists in using one fully dedicated cluster per application to maximize the level of isolation. This extreme approach still allows you to use Calico and the likes to rule east-west traffic within the application itself. 

### Pros
- Maximum isolation
- Easy
### Cons
- Costly as you have to pay the overhead of the system node pool. Beware that a production-grade cluster should run mimimum 3 nodes for the system node pool.
- Many many clusters to upgrade. This requires a well industrialized operational team.

## Splitting parts of the application across clusters

An even more extreme approach consists in splitting a single application across multiple clusters using different spokes and to put a firewall (hub) in between. 

### Pros
- Maximum isolation
### Cons
- Extremely costly as you have to pay the overhead of the system node pool per application layer. Beware that a production-grade cluster should run mimimum 3 nodes for the system node pool.
- Many many clusters to upgrade if you do that for all yours apps. This requires a well industrialized operational team.
- Increased complexity

## Clustering applications per layer

### Pros
- Maximum isolation
- Economies of scale after a certain number of apps have been deployed to the clusters.
### Cons
- Still costlier than a single cluster, as you have to pay the overhead of the system node pool per application layer. Beware that a production-grade cluster should run mimimum 3 nodes for the system node pool.
- Increased complexity


# Topics discussed in this section

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Project Calico and Network Security Groups | This diagram shows how to leverage Network Security Groups and Project Calico to control internal cluster traffic|[east-west-through-calico-and-nsg](./east-west-through-calico-and-nsg.md) |
| East-West traffic through Calico, Network Security Groups and Azure Firewall | This diagram shows how to leverage Project Calico, NSGs and Azure Firewall to control internal cluster traffic|[east-west-through-calico-nsg-fw](./east-west-through-calico-nsg-fw.md) |
| East-West traffic through Project Calico | This diagram shows how to leverage Project Calico to control internal cluster traffic in a Cloud native way|[east-west-through-calico](./east-west-through-calico.md) |
| East-West traffic variants | This page depicts a few extreme approaches to handle east-west traffic within AKS.|[east-west-aks-variants](./east-west-aks-variants.md) |