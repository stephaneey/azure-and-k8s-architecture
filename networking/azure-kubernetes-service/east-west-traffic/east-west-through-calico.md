# Using Project Calico Network Policy to handle east-west traffic (Cloud native)

> First things first, I am featuring here the Calico Network Policy, which must not be confused with Calico CNI Plugin.
![eastwest-aks-calico](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/aks-east-west-calico.png)
> Tip: right click on the diagram and choose 'Open image in a new tab'
# Attention Points

## (1) AKS Spoke

As highlighted in this section's readme file, AKS cannot span multiple spokes. This means that no matter how you want to manage east-west traffic, and no matter how many applications are hosted in the cluster, you are restricted to a single virtual network.

## (2) System Node Pool and User Node Pool(s)

It is a best practice to split both node pools. The reason is that you want to avoid pollution of the system node pools by user workloads. To achieve this, you can taint your system node pool and make sure only system workloads, such as add-ons and extensions tolerate those taints. Regular workloads should be scheduled on user node pools.

Another reason why it is interesting to split system from non-system node pools, is because load balancer IPs sit in the system node pool, which lets you apply specific Network Security Group rules, such as for instance, only let Application Gateway talk to these IPs. Make sure not to restrict the system node pool subnet's NSG to Application Gateway only. A few built-in K8s ports should **always** be allowed as listed on [this page](https://www.tigera.io/learn/guides/kubernetes-security/kubernetes-firewall/). Another best practice consists in configuring zone-redundant node pools, to ensure high-availability. Note that you still have identify the nature of the applications hosted in the cluster carefully. Indeed, while enabling zone-redundancy is a best practice, it can be a game changer for very chatty applications. What I mean is that you might have pod-to-pod traffic across zones, which incur an extra latency of +=2ms. You should also carefully consider the external services (SQL,Redis, etc.) pods might be talking to, as they could also generate inter-zone traffic if pods and data stores are not in the same zone. So, make sure that everything is aligned to avoid unexpected impact on performance.

## (3) Using Calico Network Policy

Calico is compatible with Kubenet, Azure CNI and Azure CNI Overlay, which makes it a good candidate to govern network rules within an AKS cluster. It's preferred over Azure Network Policy because it is richer and can be used in any K8s cluster, wheter on Azure or not.

Calico's main components are:
- Calico node: daemonset encompassing Felix and BIRD, which make sure routes and network ACLs are programmed according to the defined rules.
- Calico typha: acts as a proxy to help Calico scale in large environments
- Calico controller: monitors the state of the Calico dataplane

When using Calico, we typically start with the following rules:

- Deny all traffic by default using global network policies. Make sure to exempt system namespaces inclulding calico itself from these policies. Note that this kind of policy is not limited to east-west traffic but also north-south. Indeed, with a global deny policy, pods are also not allowed to go to internet.
- Allow all pods to consume the DNS service, else nothing works anymore.
- Open up gradually according to the needs.

I have provided you with [sample policies & workloads](./calico) for you to test. More on this at the end of this page.

## (4) Cross-namespace traffic

As highlighted before, by default, pods can talk to each other with no restriction whatever namespace they are in. When hosting multiple applications within the same cluster, you want to enforce some boundaries to prevent an infected process from doing lateral movements within the cluster. You will typicall use global network policies to define how namespaces can interact with each other.

## (5) Intra-namespace traffic
Depending on your security requirements, you may decide to:

- Override the global deny policy with a namespace-scoped policy or another global policy to allow intra-namespace traffic with no restriction
- Override the global deny policy with a namespace-scoped policy or another global policy with specific restrictions, such as only the *frontend* pods could talk to the *backend* pods and only the backend pods could reach out to *private endpoints* that are used to access data services.

# Sample policies and workloads

I have provided you with a [sample](./calico) set of network policies and workloads for testing purposes. The example provides:

- A few global policies that deny all traffic for non-system namespaces, while still allowing traffic to DNS (any other shared service should also be allowed). The policy file also includes an example on how to allow traffic from one namespace to another and how to allow intra-namespace traffic.
- A few deployments using two different namespaces, in which, two busybox and two NGINX are deployed.Namespace1 can talk to namespace2 as well as to itself.
- An extra namespace named *ntierapp* which allows *frontend* pods to talk to *backend* pods using dynamic selectors.

To test this out, you must:
- Deploy the calico policies with the *calicoctl* command-line tool such as:
`calicoctl apply -f "<path-to-file>" --config=calico.cfg.yaml --allow-version-mismatch`. The *--allow-version-mismatch* flag is optional. If you are using Windows, you will need to craft a Calico configuration file for Calico to find the API server.
- Deploy the *sampleworkloads.yaml* file using *kubectl*.

Once you have deployed everything, you can connect to a given busybox with *kubectl exec* and try to perform *wget* calls against the NGINX service. This allows you to see both Calico and NSG restrictions in action. An example of such a call could be:

`wget http://nginx-service.namespace1.svc.cluster.local`

for intra-namespace traffic, and:

`wget http://nginx-service.namespace2.svc.cluster.local`

for cross-namespace traffic, providing you execed into the namespace1's busybox.

# Pros & cons of using Project Calico to enforce network policies

## Pros

- Increased control over East-West traffic within a K8s cluster, as well as egress traffic (internet)
- Prevents unexpected lateral movements inside the cluster
- Network becomes programmable as you can associate policies with labels, which makes rules very dynamic.
- Although Project Calico is open source, it is a built-in feature of AKS, thus supported by Microsoft.

## Cons

- K8s-level network policies, as well as service-mesh L7 policies (not shown here) **do not** protect you against container escape threats. Any container-engine level or operating-system level vulnerability that would allow malicious code to escape the container, results in an access to the underlying operating system. Once in the OS, the process is totally non-sensitive to K8s and will not be restricted by our calico policies.
- Project Calico isn't the easiest open source solution to use.
- Visibility at scale over all network rules is not great, especially when using multiple clusters.

# Real-world observation
I have seen Calico used in nearly every cluster so far. For enteprise-grade environment, you might consider using Calico Enterprise or another tool, to improve visiblity and manageability. Many organizations accept to rely only on logical isolation and Calico Network Policies (or other solutions), often combined with a Service Mesh solution acting at layer-7. Using Project Calico or similar tools is the **most** cloud native way of handling east-west traffic in the K8s world. 

# Topics discussed in this section

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| East-West traffic through Project Calico and Network Security Groups | This diagram shows how to leverage Network Security Groups and Project Calico to control internal cluster traffic|[east-west-through-calico-and-nsg](./east-west-through-calico-and-nsg.md) |
| East-West traffic through Calico, Network Security Groups and Azure Firewall | This diagram shows how to leverage Project Calico, NSGs and Azure Firewall to control internal cluster traffic|[east-west-through-calico-nsg-fw](./east-west-through-calico-nsg-fw.md) |
| East-West traffic through Project Calico | This diagram shows how to leverage Project Calico to control internal cluster traffic in a Cloud native way|[east-west-through-calico](./east-west-through-calico.md) |
| East-West traffic variants | This page depicts a few extreme approaches to handle east-west traffic within AKS.|[east-west-aks-variants](./east-west-aks-variants.md) |