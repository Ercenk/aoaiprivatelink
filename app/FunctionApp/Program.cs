using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using JokeService;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureAppConfiguration(builder =>
    {
        builder.AddUserSecrets(typeof(Program).Assembly, optional: true);
    })
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
        // The service assumes the configuration is available and the following values are present
        // "KEYVAULTURI": "https://custdb-kv.vault.azure.net/",
        // "OPENAI_DEPLOYMENT_NAME": "text-davinci-003",
        // "OPENAI_MODEL_ID": "text-davinci-003",
        // "USEAZURECREDS": "true"
        //"aoiEndpoint": "",
        //"aoaiKey": ""

        // if USEAZURECREDS is true aoaiKey is ignored
        services.AddSingleton<IJokeMachine, JokeMachine>();
    })
    .Build();

host.Run();
