
# Using a firewall to handle East-West traffic with Azure Virtual WAN (VWAN)
![eastwest-option3](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/east-west-through-vwan-fw.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points
## (1) Secure Virtual Hub
When using VWAN, you must at least have one virtual hub that you will connect spokes, as well as non-Azure data centres to. When using Azure Firewall or a Virtual Network Appliance, you turn the virtual hub as a Secure Virtual Hub. These types of hubs are fully managed and operated by Microsoft. For that reason, you cannot install anything inside the hub. 

## (2) Virtual network connections
Spokes join the VWAN by connecting to one or more hubs. To enforce traffic through the firewall, the *Propagate to None* property must be set to *true* and the connection must be associated to the *default* route table. In the security configuration settings, you can ask VWAN to route all private traffic to the firewall, which will update the default route table accordingly. Every other spoke that is associated to the *Default* route table will be routed to the firewall.


## (3) Routing traffic to the Firewall
You can either manage the default route table manually or let VWAN redirect private traffic to the firewall for you. If you associate virtual network connections to the default route table, you do not need to define return routes. In case you associate connections to a different route table, you must pay particular attention to the return routes.

## (4) Configuring the firewall

Once traffic is routed to the firewall, you still need to configure either network either application rules. 

# Pros & cons of this approach

## Pros
- Routing is faciliated by VWAN
- Increased control over East-West traffic
- Possibility to leverage IDPS features to detect malicious traffic

## Cons

- Firewall could become a bottleneck at scale, from a manageability perspective
- Costs incurred by the firewall


# Real-world observation

VWAN is as a mesh network (any-to-any communication), which initially did not offer the same level of control as a traditional (manual) Hub & Spoke network. Many organizations who started using VWAN in the early days were more flexible on east-west traffic, meaning that not everything was hoping to a firewall. This was especially true for intra-branch traffic. Now that Azure Firewall and third-party NVAs can be added to VWAN, they became as a way to control east-west traffic as in a manual Hub & Spoke architecture. 

# Other pages on this topic

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Azure Firewall | This diagram shows how to leverage Azure Firewall to control spoke to spoke communication|[east-west-through-firewall](./east-west-through-fw.md) |
| East-West traffic through Gateway Transit | This diagram shows how to leverage Azure Virtual Network Gateway to control spoke to spoke communication|[east-west-through-virtual-network-gateway](./east-west-through-gtw.md) |
| East-West traffic through purose-builot Integration Hub | This diagram shows how to split hybrid traffic from integration traffic, through the use of a purpose-built integration hub|[east-west-through-purpose-built-hub](./east-west-through-int-hub.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's secure virtual hub to control spoke to spoke communication|[east-west-through-vwan-fw](./east-west-through-vwan-fw.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's virtual hub to control spoke to spoke communication|[east-west-through-vwan](./east-west-through-vwan-no-fw.md) |
| Variants | This page shows a few variants of the above to  handle spoke to spoke communication|[east-west-variants](./east-west-variants.md) |