# Managing East-West traffic in Azure
In a Hub & Spoke topology, East-West traffic is typically referred to as traffic going from one spoke to another, so from one virtual network to another.

This traffic is always internal-only traffic within your Azure perimeter. Some organizations are flexible in the way they manage such traffic, while others want to enforce specific controls over these network flows. As always, there are multiple ways to handle such traffic. Diagrams in this section only include Azure native services but we can achieve the same (or even more) with third-party solutions.

Note that the diagrams represent the most simplistic view of a real-world situtation. Many organizations deal with hundreds if not thousands of virtual networks, with a hard split between production and non-production, requiring ofen multiple hubs, etc. However, the principles highlighted in the ad-hoc diagrams still apply.

In this section, we have:

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Azure Firewall | This diagram shows how to leverage Azure Firewall to control spoke to spoke communication|[east-west-through-firewall](./east-west-through-fw.md) |
| East-West traffic through Gateway Transit | This diagram shows how to leverage Azure Virtual Network Gateway to control spoke to spoke communication|[east-west-through-virtual-network-gateway](./east-west-through-gtw.md) |
| East-West traffic through purose-builot Integration Hub | This diagram shows how to split hybrid traffic from integration traffic, through the use of a purpose-built integration hub|[east-west-through-purpose-built-hub](./east-west-through-int-hub.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's secure virtual hub to control spoke to spoke communication|[east-west-through-vwan-fw](./east-west-through-vwan-fw.md) |
| East-West traffic in Virtual WAN through Secure Virtual Hub | This diagram shows how to leverage Azure Virtual WAN's virtual hub to control spoke to spoke communication|[east-west-through-vwan](./east-west-through-vwan-no-fw.md) |
| Variants | This page shows a few variants of the above to  handle spoke to spoke communication|[east-west-variants](./east-west-variants.md) |

