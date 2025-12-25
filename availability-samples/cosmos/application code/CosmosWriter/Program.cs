using Azure.Core;
using Azure.Identity;
using CosmosWriter;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Settings;
using System;
using System.Configuration;
using System.Net.Mime;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton((IServiceProvider serviceProvider) =>
{
    var configuration = serviceProvider.GetRequiredService<IConfiguration>();
    string endpointUrl = configuration["EndpointUrl"];    

    var preferredRegions = new List<string> { configuration["PreferredRegions"] };
  
  return new CosmosClient(endpointUrl, new DefaultAzureCredential(), new CosmosClientOptions  
  {
        ApplicationPreferredRegions = preferredRegions
  });    
});

builder.Services.AddSingleton(sp =>
{
    
    var client = sp.GetRequiredService<CosmosClient>();
    var configuration = sp.GetRequiredService<IConfiguration>();

    return client
        .GetDatabase(configuration["db"])
        .GetContainer(configuration["container"]);
});

builder.Services.AddSingleton((IServiceProvider serviceProvider) =>
{
    var configuration = serviceProvider.GetRequiredService<IConfiguration>();
    return new RuntimeSettings(configuration["BackendLocation"]);
});
    

builder.Services.AddHealthChecks();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthorization();

#pragma warning disable ASP0014 // Suggest using top level route registrations
app.UseEndpoints(endpoints =>
{
    endpoints.MapHealthChecks("/health", new HealthCheckOptions
    {
        
        ResponseWriter = async (context, report) =>
        {
            if (report.Status == HealthStatus.Healthy)
            {
                await context.Response.WriteAsync("");
            }
            else
            {
                context.Response.ContentType = MediaTypeNames.Application.Json;
                await context.Response.WriteAsync(
                    System.Text.Json.JsonSerializer.Serialize(new { status = report.Status.ToString() }));
            }
        }
    });
    endpoints.MapControllers();
});
#pragma warning restore ASP0014 // Suggest using top level route registrations

app.Run();
