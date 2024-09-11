# APIM Hotrod Show
Hey folks, we're discussing many integration-related topics on our Youtube channel, so feel free to watch and subsribe.
![alt text](/images/apimhotrodshow.png)
# Integration Platform as a Service (IPaaS)

IPaaS is a set of Azure services that are meant to satisfy most integration patteners. The main integration architecture patterns are:

- EDA Event-Driven Architecture
    - Pub/Sub
    - Event Notification (ie: webhooks)
    - ...
    
- API-driven architectutre
- Messaging
- Data-specific patterns (ie: ETL and ELT, File Transert, etc.)

On top, these patterns often rely on orchestrations or choreographies.

# Topics discussed in this section

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| BizTalk-like IPaaS | This diagram shows how to leverage IPaaS to have a Bitalk-like experience, along with the pros & cons of such an approach|[BizTalk-like-IPaaS](./patterns/biztalk-like-IPaaS-pattern.md) |
| Events vs Messages | Explanation the key differences between Events and Messages|[events-vs-messages](./patterns/event-driven-and-messaging-architecture) |
| Point-to-point (P2P) pattern | Explanation of P2P with benefits and drawbacks|[P2P-pattern](./patterns/event-driven-and-messaging-architecture/point-to-point.md) |
| Load Levelling pattern | Explanation of Load Levelling, which is some sort of P2P within a single application|[load-levelling-pattern](./patterns/event-driven-and-messaging-architecture/load-levelling.md) |
| PUB/SUB pattern with Event Grid PUSH/PUSH| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PUSH mode|[event-grid-push-push](./patterns/event-driven-and-messaging-architecture/pub-sub-event-grid.md) |
| PUB/SUB pattern with Event Grid PUSH/PULL| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PULL mode|[event-grid-push-pull](./patterns/event-driven-and-messaging-architecture/pub-sub-event-grid-pull.md) |
| PUB/SUB pattern with Service Bus PUSH/PULL| Explanation of PUB/SUB pattern with benefits and drawbacks when using Service Bus in PUSH/PULL mode|[service-bus-push-pull](./patterns/event-driven-and-messaging-architecture/pub-sub-servicebus.md) |
| PUB/SUB pattern in PUSH/PUSH/PULL with two variants| Explanation of a less common pattern based on PUSH/PUSH/PULL.|[pub-sub-push-push-pull](./patterns/event-driven-and-messaging-architecture/pub-sub-push-push-pull.md) |
| API Management topologies | This diagram illustrates the internet exposure of Azure API Management according to its pricing tier and the chosen WAF technology|[apim-topologies](./api%20management/topologies.md) |
| Multi-region API platform with Front Door in the driving seat| This diagram shows how to leverage Front Door's native load balancing algos to expose a globally available API platform|[frontdoor-apim-option1](./api%20management/multi-region-setup/frontdoorapim1.md) |
| Multi-region API platform with APIM in the driving seat| This diagram shows how to leverage APIM's native load balancing algo to expose a globally available API platform|[frontdoor-apim-option2](./api%20management/multi-region-setup/frontdoorapim2.md) |