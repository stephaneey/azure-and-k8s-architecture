using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.DurableTask;
using Microsoft.DurableTask.Client;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Text.Json;

namespace DurableFunctionStateFailoverExample;

public static class Function1
{
    [Function(nameof(Function1))]
    public static async Task RunOrchestrator(
        [OrchestrationTrigger] TaskOrchestrationContext context)
    {
        ILogger logger = context.CreateReplaySafeLogger(nameof(Function1));
        logger.LogInformation("Waiting for external event");      
        var eventData=await context.WaitForExternalEvent<DateTime>("event");
        logger.LogInformation("external event received {0}", eventData.ToString());        
    }

    
    [Function("Function1_HttpStart")]
    public static async Task<HttpResponseData> HttpStart(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req,
        [DurableClient] DurableTaskClient client,
        FunctionContext executionContext)
    {
        ILogger logger = executionContext.GetLogger("Function1_HttpStart");

        // Function input comes from the request content.
        string instanceId = await client.ScheduleNewOrchestrationInstanceAsync(
            nameof(Function1));

        logger.LogInformation("Started orchestration with ID = '{instanceId}'.", instanceId);
        
        return await client.CreateCheckStatusResponseAsync(req, instanceId);
    }

    [Function("SendExternalEvent")]
    public static async Task<HttpResponseData> SendExternalEvent(
    [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        [DurableClient] DurableTaskClient client,
        FunctionContext executionContext)
    {
        string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var data = JsonSerializer.Deserialize<RequestPayload>(requestBody); 
        string instanceId = data?.instanceId;
        if(instanceId != null)
        {
            await client.RaiseEventAsync(instanceId, "event", DateTime.Now);
            return req.CreateResponse(HttpStatusCode.OK);
        }
        
        return req.CreateResponse(HttpStatusCode.BadRequest);

    }

    /*
       {
         "instanceId": "<ID retrieved from the first HTTP request>"
       }
    */
}
public class RequestPayload { public string instanceId { get; set; } }
