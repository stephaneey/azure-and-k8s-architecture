
# Using a purpose-built integration hub to handle east-west traffic
![eastwest-option3](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/east-west-through-int-hub.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points
## (1) S2S VPN, Expressroute or both
You can opt for S2S VPN, Expressroute or both at the same time. While Azure Expressroute offers layer 2 type of connectivity, it does not encrypt traffic in transit. This is why organizations often use an IPSEC tunnel over Expressroute. 

## (2) Hub & Firewall
In this setup, the main hub is not used for East-West traffic and only ensures hybrid traffic and outgoing traffic to internet (not shown in the diagram)

## (2') Hub & Firewall
In this setup, we use a purpose-built integration hub. This hub is only dealing with East-West traffic. Spokes that must talk to each other must be peered to this hub.
The firewall must allow *spoke1* to talk to *spoke2* and/or *spoke2* to talk to *spoke1*. Azure Firewall is stateful so it's not required to add rules in both directions. Rules are of type *network rules* and *application rules*. By default, network rules do not perform SNAT. This means that a return route is required at the destination (bullet 3 in the diagram). Application rules perform SNAT, for which no return route is required.

## (3) Routing traffic to the Firewall
Since virtual network peering is not transitive, you must define explicit routes to route traffic to the firewall. The principle is simple:

- In the source, you define a route to the destination
- You specify a *Next Hop* of type *Virtual Appliance* and you specify the private IP of your firewall. 

As highlighted in the previous paragraph, you must define return routes at the destination if you are using Network Rules in the firewall. Not defining such routes would lead to an asymmetric routing situation. Peerings between the Hub and the Spokes must allow the Hub to forward traffic to the spokes.

Note that depending on whether you work with Azure Firewall or a third-party Network Virtual Appliance, you might want to add *Route Server* to the mix to help deal with the routing.

# Pros & cons of this approach

## Pros

- Increased control over East-West traffic
- Prevent unexpected lateral movement
- Possibility to leverage IDPS features to detect malicious traffic
- Leverage Virtual Network Peering as a way to bring an extra network capability (ie: east-west movement)
- Possibility to remove the east-west traffic capability while not impacting the hybrid one.
- Specialized hubs help reduce blast radius in case of configuration mistakes, as opposed to a single hub approach where a single configuration mistake could open doors to unexpected network movements.
- Easier to audit
## Cons

- Costs incurred by the purpose-built hub

# Real-world observation

Using a purpose-built hub to manage east-west traffic is not that frequent and is a concept that can be seen in financial and highly regulated sectors.

# Other pages on this topic

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Azure Firewall | This diagram shows how to leverage Azure Firewall to control spoke to spoke communication|[east-west-through-firewall](./east-west-through-fw.md) |
| East-West traffic through Gateway Transit | This diagram shows how to leverage Azure Virtual Network Gateway to control spoke to spoke communication|[east-west-through-virtual-network-gateway](./east-west-through-gtw.md) |
| East-West traffic through purose-builot Integration Hub | This diagram shows how to split hybrid traffic from integration traffic, through the use of a purpose-built integration hub|[east-west-through-purpose-built-hub](./east-west-through-int-hub.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's secure virtual hub to control spoke to spoke communication|[east-west-through-vwan-fw](./east-west-through-vwan-fw.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's virtual hub to control spoke to spoke communication|[east-west-through-vwan](./east-west-through-vwan-no-fw.md) |
| Variants | This page shows a few variants of the above to  handle spoke to spoke communication|[east-west-variants](./east-west-variants.md) |