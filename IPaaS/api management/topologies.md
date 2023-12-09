
# Diagram
![apim-topologies](../images/apim-topologies.png)

# Attention Points
## Front Door
In 12/2023, no matter which pricing tier of API Management you are working with, it must be internet facing because Front Door does not yet support origins with APIM private endpoints, nor APIM's internal load balancer.  
## Distinguishing inbound and outbound traffic 
You must distinguish inbound and outbound traffic. For instance, API Management Basic and Standard support private endpoints, which allows you to isolate APIM from internet. However, they do not support any type of VNET integration, which means that they can only talk to internet facing backends. The second diagram illustrates this.
On the other end, you might perfectly have an internet facing inbound (diagram 4), which can talk to private backend through VNET integration. This is now possible using BasicV2 and StandardV2 pricing tiers. In 12/2023, they still do not support private endpoints, which means that they are internet facing, whatever WAF you are using in front...

## Premium all the way
Despites the latest new tiers (BasicV2 and StandardV2) should ultimately support private endpoints, APIM premium and DEV, remain the only tiers which are fully integrated within a virtual network. Note that once again, when using Front Door, you must set APIM premium in VNET External mode (public inbound, private outbound).


# Whishlist
It would be very nice to have Front Door being able to talk to:

- APIM private endpoints
- APIM Premium's internal load balancer

It is very frustrating today to be forced to run APIM on Internet because Front Door can't otherwise take it as an origin.