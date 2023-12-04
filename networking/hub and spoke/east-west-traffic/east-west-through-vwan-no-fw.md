
# Using Virtual WAN (VWAN) without a firewall to handle east-west traffic
![eastwest-option3](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/east-west-through-vwan-nofw.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points
## (1) Virtual Hub
When using VWAN, you must at least have one virtual hub that you will connect spokes, as well as non-Azure data centres to. Virtual hubs are fully managed and operated by Microsoft. For that reason, you cannot install anything inside the hub. 

## (2) Virtual network connections
Spokes join the VWAN by connecting to one or more hubs. Spokes joining a given hub can by design talk to each other, providing they propagate their connection to the default route table. To make sure this is the case, *Propagate to None* must be set to *false* and *Propagate to route table* must be set to *Default*. Every other spoke that is associated to the *Default* route table will see the new spoke.

# Pros & cons of this approach

## Pros
- Routing is faciliated by VWAN
- Easy to manage
- Cheaper than with a NVA or Azure Firewall

## Cons

- No possibility to leverage IDPS features to detect malicious traffic
- Less visibility over the network flows

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