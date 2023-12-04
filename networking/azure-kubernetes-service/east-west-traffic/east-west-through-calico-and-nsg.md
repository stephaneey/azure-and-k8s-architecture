# Using Network Security Groups combined with Project Calico Network Policy to handle east-west traffic on an Azure-CNI-enabled cluster

This approach is less Cloud native than working with Calico only. As the pure Calico-based approach is explained [here](./east-west-through-calico.md), I will not repeat how it works and will focus instead on Network Security Groups.
![eastwest-aks-calico-nsg](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/aks-east-west-calico-nsg.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points

## (1) AKS Spoke

As highlighted in this section's readme file, AKS cannot span multiple spokes. This means that no matter how you want to manage east-west traffic, and no matter how many applications are hosted in the cluster, you are restricted to a single virtual network.

## (2) System Node Pool and User Node Pools

It is a best practice to split both node pools. The reason is that you want to avoid pollution of the system node pools by user workloads. To achieve this, you can taint your system node pool and make sure only system workloads, such as add-ons and extensions tolerate those taints. Regular workloads should be scheduled on user node pools.

Another reason why it is interesting to split system from non-system node pools, is because load balancer IPs sit in the system node pool, which lets you apply specific Network Security Group rules, such as for instance, only let Application Gateway talk to these IPs. Make sure not to restrict the system node pool subnet's NSG to Application Gateway only. A few built-in K8s ports should **always** be allowed as listed on [this page](https://www.tigera.io/learn/guides/kubernetes-security/kubernetes-firewall/). 

When using Network Security Groups to handle east-west traffic, you want to enforce stricter boundaries across applications or tenants. You may consider each application as a separate tenant and isolate it into its own dedicated nodepool and subnet. Doing so, you can rely not only on Calico network policies, but also on NSGs to rule traffic across applications.

Another best practice consists in configuring zone-redundant node pools, to ensure high-availability. Note that you still have identify the nature of the applications hosted in the cluster carefully. Indeed, while enabling zone-redundancy is a best practice, it can be a game changer for very chatty applications. What I mean is that you might have pod-to-pod traffic across zones, which incur an extra latency of +=2ms. You should also carefully consider the external services (SQL,Redis, etc.) pods might be talking to, as they could also generate inter-zone traffic if pods and data stores are not in the same zone. So, make sure that everything is aligned to avoid unexpected impact on performance.

## (3) Using K8s'built-in scheduling features to isolate workloads

By having dedicated zone-redundant node pools per tenant, we can make sure tenant-specific workloads get scheduled to the right set of nodes using *NodeAffinity* to force the scheduler to only select nodes that match our filter. In this example, each node pool is labelled with the label *stack* and its corresponding value such as *tenant1* and *tenant2*. 

## (4) Using Network Security Groups (NSGs) to handle east-west traffic across tenants
On top of ruling traffic with Calico [as explained on the dedicated page](./east-west-through-calico.md), you can ensure stricter isolation by leveraging Network Security Groups. For each NSG associated to a given tenant/namespace/subnet, make sure to:

- Let the system node pool talk to the user node pools (subnets).
- Allow intra-subnet traffic.
- Allow ServiceTags such as AzureLoadBalancer, as this might be required depending on how you manage ingress.
- Allow system ports used by the Kubelet and the control plane in general.
- Add a *DenyAll* rule to prevent other subnets to talk to the current subnet.

## (5) Intra-namespace traffic
I do not recommend to manage intra-namespace traffic with NSGs. Try to stick to Calico for this, [as explained on the dedicated page](./east-west-through-calico.md)

# Sample workloads

I have provided you with a few [examples](./calico) for testing purposes. On top of Calico policies, I have provided an additional sample file named *strictisolation.yaml*, to feature how you can make sure pods get scheduled into their respective tenant-specific node pool using *NodeAffinity*.

To test this out, including the Calico bits you must:
- Deploy the calico policies with the *calicoctl* command-line tool such as:
`calicoctl apply -f "<path-to-file>" --config=calico.cfg.yaml --allow-version-mismatch`. The *--allow-version-mismatch* flag is optional. If you are using Windows, you will need to craft a Calico configuration file for Calico to find the API server.
- Deploy the *sampleworkloads.yaml* file using *kubectl*
- Deploy the *strictisolation.yaml* file using *kubectl*. This YAML file assumes that you have labelled your tenant-specific node pools, as illustrated below:

`az aks nodepool update --cluster-name eastwest --resource-group eastwest --name user2 --labels stack=user2`
- You also need to make sure to configure the NSGs as explained in the previous sections.

Once you have deployed everything, you can connect to a given busybox with *kubectl exec* and try to perform *wget* calls against the NGINX service. This allows you to see both Calico and NSG restrictions in action. An example of such a call could be:

`wget http://nginx-service.tenant1.svc.cluster.local`

for intra-namespace (tenant) traffic, and:

`wget http://nginx-service.tenant2.svc.cluster.local`

for cross-namespace (tenant) traffic, providing you execed into the tenant1's busybox.

# Important note
The network plugin you choose (Azure CNI, Kubenet, CNI Overlay or BYOCNI) is very important in this setup. A true CNI plugin such as Azure CNI will allocate a routable IP to each pod and each node. This means that NSG rules can use the actual subnet ranges in the *source* and *destination* IPs. When using Kubenet, pods get a non-routable IP using a technique called IP masquerading. In other words, you cannot use pod ranges in NSG or Firewall rules to restrict a given application to talk to another one, because they keep changing. When using Kubenet, AKS dynamically maps subnet ranges with POD CIDRs and there is no way to force a certain node pool (subnet aka tenant in our scenario) to allocate a certain POD CIDRs. So, typically, you must deny all traffic, except the **entire** POD CIDR in the NSG/Firewall rules, as well as the system ports and load balancer, and rely on Calico to rule internal traffic. Doing so still prevents unexpected lateral movements across nodes belonging to different node pools. When using Kubnet, you **must** use both Calico and NSG to rule both K8s level and node level traffic.

# Pros & cons of using NSGs and Project Calico to enforce network policies

## Pros

- Same pros as the ones applying to Project Calico or similar products
- Unlike internal network policies, NSGs help prevent unexpected lateral movements across **nodes** belonging to different node pools. This is a useful mitigation against node-level attacks such as container escape and other types of operating-system level intrusions. With such a setup, an infected tenant could not easily contaminate its neighbors.
- Overall more secure than using a single container-based approach.

## Cons

- Same cons as the ones applying to Project Calico or similar products, except the escape from container attack.
- Pod density is likely **not** to be optimal when isolating each application or tenant into its own dedicated node pool.
- K8s'built-in plasticity is impacted as we force pods to be scheduled on specific nodes. In case of major outage or problem, it will be much harder for K8s to reschedule pods to available nodes.
- Risk of impacting the built-in K8s way of working by blocking built-in system ports and flows unexpectedly, especially upon version upgrade.
- Complexity is higher.

# Real-world observation
This type of setup is **not** Cloud native as it mixes dynamic programmable networks with rather static way of handling network security rules. It is not frequently used but I have however already encountered this.

# Other pages on this topic

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Project Calico and Network Security Groups | This diagram shows how to leverage Network Security Groups and Project Calico to control internal cluster traffic|[east-west-through-calico-nsg-fw](./east-west-through-calico-nsg-fw.md) |
| East-West traffic through Project Calico | This diagram shows how to leverage Project Calico to control internal cluster traffic in a Cloud native way|[east-west-through-calico](./east-west-through-calico.md) |
[east-west-through-calico-and-nsg](./east-west-through-calico-and-nsg.md) |
| East-West traffic through Calico, Network Security Groups and Azure Firewall | This diagram shows how to leverage Project Calico, NSGs and Azure Firewall to control internal cluster traffic|