using Newtonsoft.Json;

namespace CosmosWriter
{
    public class WeatherForecast
    {
        [JsonProperty(PropertyName = "id")]
        public String Id { get;  set; }
        public DateOnly Date { get; set; }

        public int TemperatureC { get; set; }

        public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);

        public string? Summary { get; set; }        
        
        public WeatherForecast()
        {
            
        }
    }
}
