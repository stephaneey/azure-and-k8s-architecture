# Introducing global API deployment
A global API deployment means that you have an API platform that spans more than a single region. To be global, you should be on at least three continents. The diagrams shared below only span two continents but the principle remains exactly the same, no matter how many regions/continents you work with.

## Key takeaways for such an architecture

### Premium pricing tier
 
The only API Management tier that supports multi-region is the premium one. Since it is the costliest tier, you might be tempted to deploy multiple non-premium and independent API management instances of a different tier and route traffic yourself. While this could work, you have to consider the following aspects:
- You will not be able to rely on APIM's default load balancer to load balance traffic across regional units
- You would end up with multiple control and data planes, which would force you to:
  - Deploy your APIs on each instance separately
  - Synchronize subscription keys (if you use them) across APIM instances
- You would be on your own to handle a regional failure.

### Front Door as the frontend gate
Although APIM's main endpoint is perfectly able to handle a global deployment on its own, it does not provide any Web Application Firewall (WAF) feature. This is the reason why a service such as Front Door is useful. Front Door also allows you to define advanced load balancing rules should it be required. Application Gateway cannot be used as the main entry point because it's a regional service, which wouldn't survive a regional outage.

### Internet facing requirements

In 12/23, Front Door does not integrate with fully private API Management instance. It is explained in more details in the ad-hoc diagrams and markdown files.