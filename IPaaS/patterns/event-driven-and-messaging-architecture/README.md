# Events vs Messages

The boundary between events and messages is not always clear to everyone. Here are some key differences between events and messages

- Events notify any interested party about **anything that already happened**.
- Event producers and Event Consumers are **totally decoupled**.
- Events do leverage the Publish/Subscribe pattern. 
- Event producers own the payload schema.
- Messages are often used to send a command to another service.
- Messages are often used to wait a command completion from another service.
- Messages are used in asynchronous communications between functionally **coupled** services. 
- Messages are often involved in point-to-point, load-levelling and competing-consumer patterns
- With messages, both senders and receivers need to agree on a common payload schema.

Now, here is what they have in common:

- They both leverage asynchronous communication.
- They both contribute to a more scalable architecture.
- They both contribute to a more resillient architecture.
- They both are examples of distributed architectures.


# Topics discussed in this section

| Diagram | Description |Link
| ----------- | ----------- | ----------- |
| Point-to-point (P2P) pattern | Explanation of P2P with benefits and drawbacks|[P2P-pattern](point-to-point.md) |
| Load Levelling pattern | Explanation of Load Levelling, which is some sort of P2P within a single application|[load-levelling-pattern](load-levelling.md) |
| PUB/SUB pattern with Event Grid PUSH/PUSH| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PUSH mode|[event-grid-push-push](pub-sub-event-grid.md) |
| PUB/SUB pattern with Event Grid PUSH/PULL| Explanation of PUB/SUB pattern with benefits and drawbacks when using Event Grid in PUSH/PULL mode|[event-grid-push-pull](pub-sub-event-grid-pull.md) |
| PUB/SUB pattern with Service Bus PUSH/PULL| Explanation of PUB/SUB pattern with benefits and drawbacks when using Service Bus in PUSH/PULL mode|[service-bus-push-pull](pub-sub-servicebus.md) |
| PUB/SUB pattern in PUSH/PUSH/PULL with two variants| Explanation of |[pub-sub-push-push-pull](pub-sub-push-push-pull.md) |
| API Management topologies | This diagram illustrates the internet exposure of Azure API Management according to its pricing tier and the chosen WAF technology|[apim-topologies](../../api%20management/topologies.md) |
| Multi-region API platform with Front Door in the driving seat| This diagram shows how to leverage Front Door's native load balancing algos to expose a globally available API platform|[frontdoor-apim-option1](../../api%20management/multi-region-setup/frontdoorapim1.md) |
| Multi-region API platform with APIM in the driving seat| This diagram shows how to leverage APIM's native load balancing algo to expose a globally available API platform|[frontdoor-apim-option2](../../api%20management/multi-region-setup/frontdoorapim2.md) |