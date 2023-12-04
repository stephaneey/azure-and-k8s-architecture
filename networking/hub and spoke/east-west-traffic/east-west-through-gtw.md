
# Using the Virtual Network Gateway to handle east-west traffic
![eastwest-option2](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/east-west-through-gtw.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points
## (1) S2S VPN, Expressroute or both
You can opt for S2S VPN, Expressroute or both at the same time. While Azure Expressroute offers layer 2 type of connectivity, it does not encrypt traffic in transit. This is why organizations often use an IPSEC tunnel over Expressroute. 

## (2) Hub & Gateway
In this type of east-west traffic management, you do not need to define anything at the level of the gateway itself. The way to allow *spoke1* to talk to *spoke2* and/or *spoke2* to talk to *spoke1*, is by routing traffic to the VPN Gateway, and to allow *Gateway Transit* in the virtual network peerings.

## (3) Routing traffic to the Gateway
Enabling *Gateway Tansit* in the peerings, makes your hub transitive. The only thing left to do, is to define routes at the source and destination.

- In the source, you define a route to the destination
- You specify a *Next Hop* of type *Virtual Network Gateway*.

At the destination, you define a return route to the source.

In this setup, I opted to disable gateway route propagation by disabling *Propagate Gateway Routes*. Enabling it would make the hub transitive between your on-premises environment and the spokes, which is typically something you want to avoid because hybrid traffic is potentially more important than east-west within Azure itself. 

# Pros & cons of this approach

## Pros

- Easy to manage
- Cheaper than with a NVA or Azure Firewall

## Cons

- No possibility to leverage IDPS features to detect malicious traffic
- Less visibility over the network flows
- Potential scalability issue since the VPN Gateway is also used for traffic coming from/to the on-premises data center.

# Real-world observation
This way of handling east-west traffic is frequent in AWS but not common in Azure. It is however suitable for smaller companies that want to reduce costs and may not have enough dedicated network staff to manage the firewall.

# Other pages on the same topic

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Azure Firewall | This diagram shows how to leverage Azure Firewall to control spoke to spoke communication|[east-west-through-firewall](./east-west-through-fw.md) |
| East-West traffic through Gateway Transit | This diagram shows how to leverage Azure Virtual Network Gateway to control spoke to spoke communication|[east-west-through-virtual-network-gateway](./east-west-through-gtw.md) |
| East-West traffic through purose-builot Integration Hub | This diagram shows how to split hybrid traffic from integration traffic, through the use of a purpose-built integration hub|[east-west-through-purpose-built-hub](./east-west-through-int-hub.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's secure virtual hub to control spoke to spoke communication|[east-west-through-vwan-fw](./east-west-through-vwan-fw.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's virtual hub to control spoke to spoke communication|[east-west-through-vwan](./east-west-through-vwan-no-fw.md) |
| Variants | This page shows a few variants of the above to  handle spoke to spoke communication|[east-west-variants](./east-west-variants.md) |