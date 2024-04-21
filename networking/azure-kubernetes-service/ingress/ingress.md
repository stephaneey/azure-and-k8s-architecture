# The different ways to manage ingress traffic in AKS
Ingress traffic in AKS is not an easy topic because there are many different ways to handle it. Another reason why ingress is rather tricky is because K8s itself is transitioning from the *Ingress API* to the *Gateway API* but as of 04/2024, the Gateway API is still not fully adopted and mature, which puts us in an in-between situation.

Nevertheless, some of the architectural concepts depicted in this page apply, whether we use K8s'Ingress API or the Gateway one.

# Two types of LoadBalancer Services

When deploying a K8s *LoadBalancer Service* into AKS, you have two options:

- Deploying the service with an External IP address
- Deploying the service with an Internal IP address

By default, an external IP address is used. Note that most enterprises do not do that even for Internet facing workloads because they typically have another Internet Ingress endpoint such as a WAF (Web Application Firewall) that is filtering any incoming Internet traffic. So, to meeting Enterprise-grade security requirements, you will only work with the second option. 

To mark a Load Balancer internal, you must use the following annotations:

```serviceAnnotations:
  service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  service.beta.kubernetes.io/azure-load-balancer-internal-subnet: <subnet>
```

where *subnet* lets you choose the target subnet in which you want the particular IP to be deployed. 

# Ingress controllers 

I already shed some light on the different options in the [Cluster Ingress section of the AKS Cheat Sheet](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/cheat%20sheets/aks.md). I will depict below a possible approach using Istio Ingress. Note that the overall principles should work just as fine with other ingress controllers such as NGINX, etc.

# Ingress topologies - Istio as an example
There are many moving parts (as always), but there are three ways to deploy Istio ingress controllers:
- Using the IstioOperator but this one seems to be on the deprecation path although no clear communication has been made as of 03/2024
- Using Helm  
- Using IstioCtl

I'll let you check your preferred option [here](https://istio.io/latest/docs/setup/install/operator/).

## One ingress controller for everything
![No-split](ic-no-split.png)

In the above topology, you share a single ingress controller for whatever type of traffic you are dealing with and for all the apps. Yet, I would encourage you to use a dedicated subnet and node pool to clearly segregate the ingress function from the rest of the cluster. Here are the pros & cons of such an approach.

**Pros**
- Compute friendly because there is no overhead

**Cons**
- Can be challenging to delegate ingress managament to application teams since they will all target the same gateway overall.
- No clear path between internet facing and internal facing applications
- Single point of failure

If you adopt such a topology, make sure to increase the number of replicas and use availability zones to spread the pod instances across nodes sitting in different zones.

## One ingress controller for internal traffic and one for external traffic
With AKS, we can enable the *Azure Mesh*, which leverages Istio behind the scenes and one of the supported topology is to enable two ingress channels, one for internal-only traffic and one for external traffic. However, the external ingress controller is associated with a public IP attached to the default external load balancer, which is not ideal as we typically prefer to have everything private and consolidate public endpoints through Web Application Firewalls or firewalls should you deal with non-HTTP traffic. 
![Split-External-Internal](ic-split-int-ext.png)

Here are the pros & cons of such an approach.

**Pros**
- Clear segregation between internet and internal channels, which is easier to manage at scale and gives a better visibility.
- Dedicated Network Security Group per channel

**Cons**
- Can be challenging to delegate ingress managament to application teams since they will all target the same gateway (iternal or external) overall.

Here again, you should make sure to have replicas running in different availability zones.

## One external and internal ingress controller per domain
In large clusters, you might want to regroup applications per domain and let domain owners a certain flexiblity when it comes to managing ingress traffic. 
![Domain-Split](ic-domain-split.png)
Here are the pros & cons of such an approach.

**Pros**
- Clear segregation between internet and internal channels and across application domains.
- Domain owners will not interfere with other domains since they have their own dedicated ingress controller.
- Dedicated Network Security Group per type of traffic per domain.

**Cons**
- Can be resource intensive if many domains are part of the same cluster.
- If you isolate (not mandatory) dedicated ingress controllers in their own subnet, you will burn many IPs (5 Azure-reserved IP per subnet).

Of course, you would only deploy a dedicated ingress controller per domain and traffic type if exposure outside of the cluster, internet or not, is required.

## One external and internal ingress controller per application
![Application-Split](ic-app-split.png)
Here are the pros & cons of such an approach.

**Pros**
- Clear segregation between internet and internal channels and across application domains.
- Domain owners will not interfere with other domains since they have their own dedicated ingress controller.
- Dedicated Network Security Group per type of traffic per domain.

**Cons**
- Can be resource intensive if many applications are part of the same cluster.
- If you isolate (not mandatory) dedicated ingress controllers in their own subnet, you will burn many IPs (5 Azure-reserved IP per subnet).

Of course, you would only deploy a dedicated ingress controller per application and traffic type if exposure outside of the cluster, internet or not, is required.


# Summary
The Cloud native way of managing ingress traffic typically involves using one or more ingress controllers. Enterprise-grade security often requires a full isolation from Internet in order to tunnel all Internet incoming traffic to a Web Application Firewall. This typically means that you should in practice not use a service of type *LoadBalancer* with a public IP address attached to it. The number of ingress controllers varies according to whether you use shared clusters or not, the extent to which you delegate ingress management to your application teams and the security requirements you must comply to.