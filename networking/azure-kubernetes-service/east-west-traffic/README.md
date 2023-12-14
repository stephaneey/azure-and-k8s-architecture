# Managing East-West traffic in Azure Kubernetes Service (AKS)

Other diagrams in the networking section illustrate the Hub & Spoke toplogy, either managed manually, either using VWAN. The Hub & Spoke toplogy, is a network-centric architecture where everything ends up in a virtual network in a way or another. This gives companies greater control over network traffic. There are many variants, but the spokes are virtual networks dedicated to business workloads, while the hubs play a control role, mostly to rule and inspect East-West  (spoke-to-spoke & DC-to-DC) and South-North traffic (coming from outside the private perimeter and going outside).  On top of increased control over network traffic, the Hub & Spoke model aims at sharing some services across workloads, such as DNS, Web Application Firewall (WAF) to name just a few.

Today, most PaaS services can be plugged to the Hub & Spoke model in a way or another:

- Through VNET Integration for outbound traffic
- Through Private Link for inbound traffic
- Through Microsoft-managed virtual networks for many data services.
- Natively, such as App Service Environments, Azure API Management, etc. and of course AKS!!

That is why we see a growing adoption of this model, whose the ultimate purpose is to isolate workloads from Internet and have an increased control over internet-facing workloads, for which it is functionally required to be public (ie: a mobile app talking to an API), a B2C offering, a B2B partnership, an e-business site, etc.

The Hub & Spoke model gives companies the opportunity to:

- Route traffic as they wish
- Use layer-4 & 7 firewalls
- Use Threat Intelligence, IDPS and TLS inspection
- Network micro-segmentation and workload isolation

Many companies start to follow the Microsoft Cloud Adoption Framework, by allocating a dedicated subscription and virtual network per workload. All of this is great in the realm of Hub & Spoke.

However, using Kubernetes (AKS in Azure) to host more than a single application (which is very commmon), is disruptive towards the above approach. The reason is that an AKS cluster cannot span virtual networks. This means that you might end up with a cluster hosting 30 applications or more, that are all inside a single spoke, or even a single subnet (default behavior in AKS).  In other words, you end up in such a situation:

![eastwest-aks1](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/aks-east-west.png)

By default, traffic is wide opened. Any pod can talk to any other pod.

The boundaries of the cluster can still be controlled easily by next-gen firewalls, but what happens inside the cluster belongs to the Cloud native world. The pointers below are potential solutions you can use to manage East-West traffic within an AKS cluster.

In this section, we have:

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| Cloud Native East-West traffic through Project Calico Network Policies | This diagram shows how to leverage Calico to control pod to pod communication|[east-west-through-calico](./east-west-through-calico.md) |
| East-West traffic through Project Calico Network Policies + Azure Network Security Groups| This diagram shows how to leverage Calico to control pod to pod communication and prevent node-level lateral movements using NSGs|[east-west-through-calico-and-nsg](./east-west-through-calico-and-nsg.md) |
| East-West traffic through Project Calico Network Policies + NSGs + Azure Firewall| This diagram shows how to leverage Calico to control pod to pod communication and prevent node-level lateral movements using NSGs and Azure Firewall|[east-west-through-calico-nsg-fw](./east-west-through-calico-nsg-fw.md) |
| East-West traffic variants for AKS| This page depicts a few extreme approaches to handle east-west traffic within AKS|[east-west-aks-variants](./east-west-aks-variants.md) |