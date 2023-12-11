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
| API Management topologies | This diagram illustrates the internet exposure of Azure API Management according to its pricing tier and the chosen WAF technology|[apim-topologies](./api%20management/topologies.md) |
| Biztalk-like IPaaS | This diagram shows how to leverage IPaaS to have a Bitalk-like experience, along with the pros & cons of such an approach|[Biztalk-like-IPaaS](./patterns/biztalk-like-IPaaS-pattern.md) |
| Multi-region API platform with Front Door in the driving seat| This diagram shows how to leverage Front Door's native load balancing algos to expose a globally available API platform|[frontdoor-apim-option1](./api%20management/multi-region-setup/frontdoorapim1.md) |
| Multi-region API platform with APIM in the driving seat| This diagram shows how to leverage APIM's native load balancing algo to expose a globally available API platform|[frontdoor-apim-option2](./api%20management/multi-region-setup/frontdoorapim2.md) |