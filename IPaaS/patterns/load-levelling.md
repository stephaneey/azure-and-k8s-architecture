# Load Levelling Diagram
![load-levelling](../images/loadlevelling.png)

This pattern is a design pattern that's used to even out the processing load on a system. It helps manage and reduce the pressure on resources that are invoked by a high number of concurrent requests.

In such a scenario, you typically let the BFF (Backend for Frontend) queue commands to a service bus queue (or any other broker). Background handlers do process the commands at their own pace. Note that backend handlers will be in a *Competing Consumer* situation (fist come first served).

# Pros & Cons of Load Levelling

## Pros

- Frontend is not slown down upon high-load
- The overall system is more scalable
- The different parts of the system can easily be scaled up/out differently

## Cons
No real cons about using this pattern but it brings a little more complexity than a synchronous approach because end users often like to get an immediate feedback about their actions. Here are a few options to deal with the asynchronous nature of the flow:

- The backend sends a 202 (Accepted) with a link to poll for the status. In the meantime, the frontend shows a message like "command is being executed, refresh the page or come back later.". This is not the most user-friendly approach.
- Both frontends and backends exchange information through *Azure SignalR Service* to have *near real time* status about the ongoing command. This is more complex, hence the cons.

- Depending on the frontend (ie: mobile app), the backend can send a notification (ie: Push Notification) to the client device once the job is done!

