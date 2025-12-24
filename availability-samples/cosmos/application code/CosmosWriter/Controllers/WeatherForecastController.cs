using Azure;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;
using Newtonsoft.Json.Linq;
using Settings;
using static Azure.Core.HttpHeader;

namespace CosmosWriter.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {        

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly CosmosClient _cosmosClient;
        private readonly Container _container;
        private readonly RuntimeSettings _runtimeSettings;


        public WeatherForecastController(ILogger<WeatherForecastController> logger, CosmosClient client, RuntimeSettings settings, Container container)
        {
            _logger = logger;
            _cosmosClient = client;
            _runtimeSettings = settings;
            _container = container;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        //public async Task<WeatherForecast> GetWeatherForecast()
        public async Task<IActionResult> GetWeatherForecast()
        {
           // var database = _cosmosClient.GetDatabase(_cosmosDbSettings.DatabaseName);
            //var container = database.GetContainer(_cosmosDbSettings.ContainerName);
            using var iterator = _container.GetItemQueryIterator<WeatherForecast>("SELECT top 1 * FROM c order by c.Date desc");
            
            if (iterator.HasMoreResults)
            {
                FeedResponse<WeatherForecast> item = await iterator.ReadNextAsync();
                return Ok(new
                {
                    backend = GetBackendLocation(item),
                    data = item.FirstOrDefault()
                });
            }
                

            return null;

        }
        //This write operation should seamlessly find a writable region
        [HttpPost(Name = "GenerateWeatherForecast")]
        public async Task<IActionResult> GenerateWeatherForecast()
        {
            var key = Guid.NewGuid().ToString();
            var forecast = new WeatherForecast
            {
                Id = key,
                Date = DateOnly.FromDateTime(DateTime.Now),
                Summary = "Whatever",
                TemperatureC = 32
            };
           // var database = _cosmosClient.GetDatabase(_cosmosDbSettings.DatabaseName);
           // var container = database.GetContainer(_cosmosDbSettings.ContainerName);
            var response = await _container.CreateItemAsync(forecast, new PartitionKey(key));
            
                
            var statusCode = response.StatusCode;
            
            return CreatedAtAction(nameof(GenerateWeatherForecast),
                new
                {
                    backend = await GetBackendLocation(response)
                });
                
        }

        private Task<string> GetBackendLocation(ItemResponse<WeatherForecast> resp)
        {
            var o = JObject.Parse(resp.Diagnostics.ToString());
            var tokens = o.SelectTokens("$..StorePhysicalAddress");
            return Task.FromResult(
                string.Concat("backendLocation:", _runtimeSettings.BackendLocation, " - CosmosLocation:", tokens.First().ToString()));
        }

        private Task<string> GetBackendLocation(FeedResponse<WeatherForecast> resp)
        {
            var o = JObject.Parse(resp.Diagnostics.ToString());
            var tokens = o.SelectTokens("$..StorePhysicalAddress");
            return Task.FromResult(
                string.Concat("backendLocation:", _runtimeSettings.BackendLocation, " - CosmosLocation:", tokens.First().ToString()));
        }
    }

    

}
