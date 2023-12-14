# Using Azure Firewall combined with Project Calico Network Policy and NSGs to handle east-west traffic on an Azure-CNI-enabled cluster

This approach is less Cloud native than working with Calico only. As the pure Calico-based approach is explained [here](./east-west-through-calico.md), I will not repeat how it works and will focus instead on Network Security Groups.
![eastwest-aks-calico-nsg](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/aks-east-west-calico-nsg-fw.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points

## (1) AKS Spoke

As highlighted in this section's readme file, AKS cannot span multiple spokes. This means that no matter how you want to manage east-west traffic, and no matter how many applications are hosted in the cluster, you are restricted to a single virtual network.

## (2) System Node Pool and User Node Pools

It is a best practice to split both node pools. The reason is that you want to avoid pollution of the system node pools by user workloads. To achieve this, you can taint your system node pool and make sure only system workloads, such as add-ons and extensions tolerate those taints. Regular workloads should be scheduled on user node pools.

Another reason why it is interesting to split system from non-system node pools, is because load balancer IPs sit in the system node pool, which lets you apply specific Network Security Group rules, such as for instance, only let Application Gateway talk to these IPs. Make sure not to restrict the system node pool subnet's NSG to Application Gateway only. A few built-in K8s ports should **always** be allowed as listed on [this page](https://www.tigera.io/learn/guides/kubernetes-security/kubernetes-firewall/). 

When using Network Security Groups and/or Azure Firewall to handle east-west traffic, you want to enforce stricter boundaries across applications or tenants. You may consider each application as a separate tenant and isolate it into its own dedicated nodepool and subnet. Doing so, you can rely not only on Calico network policies, but also on NSGs and Azure Firewall to rule traffic across applications.

Another best practice consists in configuring zone-redundant node pools, to ensure high-availability. Note that you still have identify the nature of the applications hosted in the cluster carefully. Indeed, while enabling zone-redundancy is a best practice, it can be a game changer for very chatty applications. What I mean is that you might have pod-to-pod traffic across zones, which incur an extra latency of +=2ms. You should also carefully consider the external services (SQL,Redis, etc.) pods might be talking to, as they could also generate inter-zone traffic if pods and data stores are not in the same zone. So, make sure that everything is aligned to avoid unexpected impact on performance.

## (3) Using K8s'built-in scheduling features to isolate workloads

By having dedicated zone-redundantn (for HA) node pools per tenant, we can make sure tenant-specific workloads get scheduled to the right set of nodes using *NodeAffinity* to force the scheduler to only select nodes that match our filter. In this example, each node pool is labelled with the label *stack* and its corresponding value such as *tenant1* and *tenant2*. 

## (4) Using Azure Firewall and Network Security Groups (NSGs) to handle east-west traffic across tenants
On top of ruling traffic with Calico [as explained on the dedicated page](./east-west-through-calico.md), and NSGs [as explained here](./east-west-through-calico-and-nsg.md), you can ensure stricter isolation by leveraging Azure Firewall. To achieve this, you must:

- Attach a route table (UDR) that routes traffic to Azure Firewall for the entire virtual network to override the default system route. In this example, I used this adress space 10.0.0.0/22 for the vnet. I have one route that sends all traffic destined to 10.0.0.0/22 to the Azure Firewall's private IP, which is 10.0.2.4. Usually, you would also send 0.0.0.0/0 to the firewall but this includes Internet egress, which I'll cover in a different section.
- Make sure to define the correct network rules in Azure Firewall, in a similar way than what we did for NSGs. Overall, you must make sure that:
-- System ports and DNS are opened for the entire cluster. Make sure to include other ports that would be used by specific third-party solutions.
-- Intra-subnet traffic is allowed
-- System subnet can talk to the others



## (5) Intra-namespace traffic
I do not recommend to manage intra-namespace traffic with Azure Firewall. Try to stick to Calico for this, [as explained on the dedicated page](./east-west-through-calico.md)

## (6) Azure Firewall

You can of course use your own Network Virtual Appliance (NVA) to achieve the same results. Azure Firewall or the NVA will likely **not** sit in the same virtual network as AKS but rather in a hub. For sake of simplicity, I represented it in the same virtual network, but the principles remain the same, except that you would have to peer your AKS vnet to the hub hosting the firewall.  

# Sample workloads

I have provided you with a few [examples](./calico) for testing purposes. On top of Calico policies, I have provided an additional sample file named *strictisolation.yaml*, to feature how you can make sure pods get scheduled into their respective tenant-specific node pool using *NodeAffinity*.

To test this out, including the Calico bits you must:
- Deploy the calico policies with the *calicoctl* command-line tool such as:
`calicoctl apply -f "<path-to-file>" --config=calico.cfg.yaml --allow-version-mismatch`. The *--allow-version-mismatch* flag is optional. If you are using Windows, you will need to craft a Calico configuration file for Calico to find the API server.
- Deploy the *sampleworkloads.yaml* file using *kubectl*
- Deploy the *strictisolation.yaml* file using *kubectl*. This YAML file assumes that you have labelled your tenant-specific node pools, as illustrated below:

`az aks nodepool update --cluster-name eastwest --resource-group eastwest --name user2 --labels stack=user2`
- You also need to make sure to route traffic to the firewall and to define the appropriate rules.

Once you have deployed everything, you can connect to a given busybox with *kubectl exec* and try to perform *wget* calls against the NGINX service. This allows you to see both Calico and NSG restrictions in action. An example of such a call could be:

`wget http://nginx-service.tenant1.svc.cluster.local`

for intra-namespace (tenant) traffic, and:

`wget http://nginx-service.tenant2.svc.cluster.local`

for cross-namespace (tenant) traffic, providing you execed into the tenant1's busybox.

# Important note
The network plugin you choose (Azure CNI, Kubenet, CNI Overlay or BYOCNI) is very important in this setup. A true CNI plugin such as Azure CNI will allocate a routable IP to each pod and each node. This means that NSG rules can use the actual subnet ranges in the *source* and *destination* IPs. When using Kubenet, pods get a non-routable IP using a technique called IP masquerading. In other words, you cannot use pod ranges in NSG or Firewall rules because they keep changing. When using Kubenet, AKS dynamically maps subnet ranges with POD CIDRs and there is no way to force a certain node pool (subnet) to allocate a certain POD CIDRs, as they change upon restart and scaling events. So, typically, you must deny all traffic, except the entire POD CIDR in the NSG/Firewall rules, as well as the system ports and load balancer, and rely on Calico to rule internal traffic. Doing so still prevents unexpected lateral movements across nodes belonging to different node pools. Another difference with Kubenet is that an Azure-managed route table is attached to your subnets to route traffic across nodes. You can add your own onto it but you cannot get rid of that managed table.

# Pros & cons of using Azure Firewall, NSGs and Project Calico to enforce network policies

## Pros

- Same pros as the ones applying to Project Calico (or similar products) and NSGs.
- Azure Firewall offers a better visibility than NSGs and/or Calico over network flows. You can as well enforce IDPS for this type of flows. I would however recommend to use behavioral patterns rather than TLS inspection, because TLS inspection requires every single container image to container the custom certificate authority (CA), including images that you do not craft yourself (ie: addons). AKS itself supports using custom CAs but this is a node-level only feature, not container-level one.  

## Cons

- Same cons as the ones applying to Project Calico (or similar products) and NSGs.
- Complexity is higher, especially when combining the three technologies at once.
- Additional costs for the Azure firewall

# Real-world observation
This type of setup is **not at all** Cloud native as it mixes dynamic programmable networks (Calico and the likes) with rather static way of handling network security rules. Using Azure Firewall or an NVA to handle east-west traffic **within** AKS is **not** commonly used.

# Topics discussed in this section

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Project Calico and Network Security Groups | This diagram shows how to leverage Network Security Groups and Project Calico to control internal cluster traffic|[east-west-through-calico-and-nsg](./east-west-through-calico-and-nsg.md) |
| East-West traffic through Calico, Network Security Groups and Azure Firewall | This diagram shows how to leverage Project Calico, NSGs and Azure Firewall to control internal cluster traffic|[east-west-through-calico-nsg-fw](./east-west-through-calico-nsg-fw.md) |
| East-West traffic through Project Calico | This diagram shows how to leverage Project Calico to control internal cluster traffic in a Cloud native way|[east-west-through-calico](./east-west-through-calico.md) |
| East-West traffic variants | This page depicts a few extreme approaches to handle east-west traffic within AKS.|[east-west-aks-variants](./east-west-aks-variants.md) |
