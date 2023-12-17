# Azure Tips
In this page, I will regroup a few tips per type of service or area.
## API Management
- Did you know that you can use **localhost** in APIM policies? This allows you to call other APIs without leaving the APIM boundaries.
- Scopes inherit from policies by default. Just remove the **&lt;base/>** tag from a given scope to stop inheritance.
- Use **named values** instead of hard-coding everything in your policies.
- Use of **policy fragments** to reuse fragments across policies.
- Leverage the **workspace** feature to share a single instance across teams.
- Make use of **revisions** to test changes without impacting consumers.
- Adopt a **KISS** approach with your policies. They should never contain business logic.
- Did you know that you have to craft your own policies for **disaster recovery** purposes?
- Did you know that you can let APIM authenticate against third-party APIs using the **credential manager** feature?
## IPaaS

- Did you know that you can use the **pull-based delivery mode with Event Grid** using Event Grid Namespaces?
- **Logic Apps is better** than Azure Durable Functions for any scenario that requires integration with **SaaS platforms**.
- Logic Apps handles **versioning** automatically while you can easily break Durable Functions if you do not pay particular attention to versioning. 

## Networking
- Port 25 is blocked in Azure. There is no way to expose SMTP over port 25 in DNAT rules! If you have legacy SMTP servers, you can expose port 587 and translate it to 25.
- To make sure private endpoints are sensitive to Network Security Group rules and/or broader IP ranges than /32, make sure to adjust this subnet level property **PrivateEndpointNetworkPolicies**.
- Using a virtual machine's NIC's **effective routes** is a good way to troubleshoot routing issues.
- Do no mix private link with access to internal perimeter. Private link only deals with **inbound** not **outbound**.
- Think **Private Link Service** when you want to expose a **load balancer** to Azure Front Door.
- Only load balancers with **NIC-based backend pools** can be exposed through Private Link Service.
- Think twice before enabling the **Propagate Gateway Routes** in a route table's configuration.
- Did you know that **Virtual Network Peering can be uni-directional**? It's something you can use to make sure a spoke cannot initiate traffic that is destined to the hub itself. Make sure *not* to use this if you share services other than firewalls & DNS inside of the hub.
- Did you know that you can manage peerings, route tables and security rules centrally using Azure Virtual Network Manager?
- Did you know that you could make a hub **transitive** through VPN Gateway? You simply need to allow gateway transit in peerings.

## DNS

- Use **DNS Private Resolver** to ensure DNS resolution from on-premises to the Cloud and vice-versa.
- Pay attention to **Private Link** when you have a multi-tenant organization or if your organization merges with another one. Private Link has a single domain per PaaS service that **cannot** be changed. Try to anticipate on the multi-tenant scenario from the ground up.
- Use a **DNS Forwarding Ruleset** with a wildcard if you need to send public domains to SaaS solutions such as CloudFlare.