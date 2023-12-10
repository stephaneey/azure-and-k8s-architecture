# API Management
- Did you know that you can use *localhost* in APIM policies? This allows you to call other APIs without leaving the APIM boundaries.
- Scopes inherit from policies by default. Just remove the *&lt;base/>* tag from a given scope to stop inheritance
- Use *named values* instead of hard-coding everything in your policies
- Make use of *policy fragments* to reuse fragments across policies
- Leverage the *workspace* feature to share a single instance across teams.
- Make use of *revisions* to test changes without impacting consumers
- Adopt a KISS approach with your policies. They should never contain business logic.
- Did you know that you have to craft your own policies for disaster recovery purposes?

# Networking
- Port 25 is blocked in Azure. There is no way to expose SMTP over port 25 in DNAT rules...
- To make sure private endpoints are sensitive to Network Security Group rules and/or broader IP ranges than /32, make sure to adjust this subnet level property *PrivateEndpointNetworkPolicies*
- Using a virtual machine's NIC's effective routes is a good way to troubleshoot routing issues
- Do no mix private link with *access to internal perimeter*. Private link only deals with *inbound* not *outbound*
- Think *Private Link Service* when you want to expose a *load balancer* to Azure Front Door
- Think twice before enabling the *Propagate Gateway Routes* in a route table's configuration
- Did you know that Virtual Network Peering can be uni-directional? It's something you can use to make sure a spoke *cannot* initiate traffic that is destined to the hub itself. Make sure *not* to use this if you share services other than firewalls & DNS inside of the hub.
- Did you know that you can manage peerings, route tables and security rules centrally using Azure Virtual Network Manager?
- Did you know that you could make a hub transitive through VPN Gateway? You simply need to allow gateway transit in peerings.