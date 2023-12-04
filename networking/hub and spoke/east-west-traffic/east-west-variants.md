
# Variants

## VWAN east-west across hubs

Because it is rather easy to create extra hubs in VWAN, you also have to consider east-west traffic accross hubs. Techniques used are similar to the spoke-to-spoke communication, with no firewall (first diagram in the picture), or by routing everything through the firewall including hub-to-hub traffic (second diagram in the picture). 

![eastwest-variants](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/variants.png)

The only difference compared to a single-hub VWAN is that if you want to make a new spoke visible to multiple hubs, you have to propagate the connection to the other hub's default route table.

# Other pages on this topic

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Azure Firewall | This diagram shows how to leverage Azure Firewall to control spoke to spoke communication|[east-west-through-firewall](./east-west-through-fw.md) |
| East-West traffic through Gateway Transit | This diagram shows how to leverage Azure Virtual Network Gateway to control spoke to spoke communication|[east-west-through-virtual-network-gateway](./east-west-through-gtw.md) |
| East-West traffic through purose-builot Integration Hub | This diagram shows how to split hybrid traffic from integration traffic, through the use of a purpose-built integration hub|[east-west-through-purpose-built-hub](./east-west-through-int-hub.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's secure virtual hub to control spoke to spoke communication|[east-west-through-vwan-fw](./east-west-through-vwan-fw.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's virtual hub to control spoke to spoke communication|[east-west-through-vwan](./east-west-through-vwan-no-fw.md) |
| Variants | This page shows a few variants of the above to  handle spoke to spoke communication|[east-west-variants](./east-west-variants.md) |