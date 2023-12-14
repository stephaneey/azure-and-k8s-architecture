# Azure and K8s Architecture
![Cloud Architecture](https://github.com/stephaneey/azure-and-k8s-architecture/blob/main/images/cloudarchidiagrams.png)

The purpose of this repo is to share some real-world inspired Azure and K8s architecture diagrams, that may help organizations accelerate their adoption of Azure and K8s. Each diagram will be accompanied by a textual explanation with the key attention points.

Each folder has purpose-built diagrams along with markdown files that highlights the attention points and shed some light on the design choices.


| Release date | Description |Link
| ----------- | ----------- | ----------- |
| 2023/11/25 | These diagrams help you understand how to deploy a global API platform. |[Multi-region API deployment in two flavors](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/api%20management/multi-region-setup) |
| 2023/12/04 | These diagrams help you understand how to handle East-West traffic in the traditional Azure Hub & Spoke as well as in Virtual WAN. |[East-West with Hub & Spoke and VWAN](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/networking/hub%20and%20spoke/east-west-traffic) |
| 2023/12/04 | These diagrams help you understand how to deploy a global API platform. |[East-West within AKS](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/networking/azure-kubernetes-service/east-west-traffic) |
| 2023/12/08 | Added a page with a Azure tips. |[Azure Tips](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/azuretips.md) |
| 2023/12/08 | Added a page with a few API Management topologies. |[Azure API Management Topologies](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/api%20management/topologies.md) |
| 2023/12/09 | Added a page showing a Biztalk-like IPaaS approach. |[Biztalk-like IPaaS approach](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/biztalk-like-IPaaS-pattern.md) |
| 2023/12/14 | Explanation of P2P with benefits and drawbacks|[P2P-pattern](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/point-to-point.md) |
| 2023/12/14| Explanation of Load Levelling, which is some sort of P2P within a single application|[load-levelling-pattern](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/load-levelling.md) |
| 2023/12/14| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PUSH mode|[event-grid-push-push](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/pub-sub-event-grid.md) |
| 2023/12/14| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PULL mode|[event-grid-push-pull](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/pub-sub-event-grid-pull.md) |
| 2023/12/14| Explanation of PUB/SUB pattern with benefits and drawbacks when using Service Bus in PUSH/PULL mode|[service-bus-push-pull](https://github.com/stephaneey/azure-and-k8s-architecture/tree/main/IPaaS/patterns/pub-sub-servicebus.md) |