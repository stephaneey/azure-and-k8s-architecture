# The different ways to manage egress traffic in AKS

Egress traffic is traffic that leaves the AKS cluster. Such traffic is often destined to Internet but could also reach out to a privatelink-enabled PaaS service. The latter can be considered East-West traffic from a broader perspective but remains egress for AKS. No matter how you consider it, you will typically route such traffic to a different appliance according to the actual destination (internet or not). By default, AKS clusters have a built-in load balancer that is used to let traffic go to Internet. You can decide to route the traffic to an Azure Firewall or an NVA intead. Before ruling how traffic that has already left the cluster should be routed, let us see what we can already do from a cluster perspective.

# Using Calico to manage egress traffic
When using Calico, you typically apply a Global Deny policy to lockdown pod-level egress traffic. This policy not only applies to cluster egress but also to internal traffic. You then deploy namespace-scoped or a global policy that allows one or more namespaces to reach the targeted destination. I explained Calico, along with concrete examples in [East-West section](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/networking/azure-kubernetes-service/east-west-traffic).

# Using Istio to manage egress traffic
Istio, now natively available with AKS, can be used to manage egress traffic thanks to its built-in egress gateway. Istio allows you to lockdown egress traffic by setting *outboundTrafficPolicy* to *REGISTRY_ONLY*. With this enabled, not only traffic destined to Internet will be blocked but even traffic destined to anything that is outside of the mesh will be denied, even if the target service is part of the cluster.

To give you a concrete example, if you use Dapr together with Istio, you will have to allow dapr-enabled applications to reach out to the Dapr controlplane which you typically do not inject. With egress locked down by default, this would result in the following situation:

![egress-dapr-istio](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/aks-dapr-istio-egress.png)

where the *daprd* sidecar would not be able to reach out to *dapr-sentry* nor any other services exposed by Dapr's controlplane. To solve this, you would have to explicitly add an Istio **ServiceEntry** : 

```apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: dapr-controlplane
  namespace: istio-system
spec:
  hosts:
  - dapr-sentry.dapr-system.svc.cluster.local  
  - dapr-api.dapr-system.svc.cluster.local  
  - dapr-placement.dapr-system.svc.cluster.local  
  location: MESH_EXTERNAL
  ports:
  - number: 443
    name: https
    protocol: TLS
  resolution: DNS
```    
to either the application namespace, either Istio's root namespace to let every meshed pod talk to the Dapr controlplane. This type of traffic is considered egress from a pod perspective, not from a cluster one, which is the reason why you shouldn't leverage Istio's egress gateway for this, while still having to add Dapr's controlplane to Istio's service registry. 

On the other hand, you would still have to manage two extra situations:

- Traffic destined to privatized PaaS services or any other Azure-hosted service 
- Traffic destined to Internet (Azure or not)

In both cases, such traffic leaves the cluster and now it becomes interesting to leverage the Egress Gateway. As you know, K8s'default behavior lets every pod talk to any other pod 

# Using both Istio and Calico to manage egress traffic

Istio and Calico are not mutually exclusive. On the contrary, they complement each other and ensure a defense in depth approach by combining different layers of controls. As we saw earlier, both Istio and Calico help manage egress traffic at the level of the pod, which is also the reason why they can both be used to also handle [East-West traffic](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/networking/azure-kubernetes-service/east-west-traffic) within the AKS cluster itself.

# Using an external appliance to manage egress traffic
Depending on the overall security posture of your organization, you might be facing the following situations:

- You use a single firewall for every type of traffic 
- You use specialized firewalls such as one for spoke-to-spoke, one for internet egress, one for internet egress, etc.
- You do not use any firewall. In that case, you should review your position :).

As highlighted earlier, traffic leaving the cluster is considered egress for AKS but such traffic can target either internet, either other Azure endpoints such as private endpoints like for instance, when a pod needs to reach out to a private-link-enabled database. The toplogies below shed some light on how you should route traffic according to the number of firewalls you have.

## Single Hub & single firewall for everything

![egress-single-hub](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/egress-single-hub.png)

In the above setup, all traffic but intra-VNET traffic is sent to the hub. Note that intra-VNET traffic could also be sent to the firewall but this is typically not done because we typically rule intra-vnet raffic with Network Security Groups. You'll be able to route traffic to the hub through the use of *User-Defined Routes¨*.

## Multi Hub Architecture

![egress-multi-hub](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/networking/images/egress-multi-hub.png)

In the above setup, you work with traffic-specific hubs where each hub only deals with specific duties (ie: internet egress, east-west, internet ingress, etc.). The principle is the same as before but this time, you'll need to differentiate the routes in your *User-Defined Routes*, according to whether the traffic is destined to internet or the internal perimeter.
