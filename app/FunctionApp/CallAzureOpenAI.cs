using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.SemanticKernel;

namespace Contoso.AzureOpenAI
{
    public class CallAzureOpenAI
    {
        private readonly ILogger logger;

        public CallAzureOpenAI(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<CallAzureOpenAI>();
        }

        [Function("CallAzureOpenAI")]
        public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequestData req)
        {
            var credential = new DefaultAzureCredential(true);

            var uriVariable = "KEYVAULTURI";
            var keyVaultEndpoint = Environment.GetEnvironmentVariable(uriVariable);

            var client = new SecretClient(new Uri(keyVaultEndpoint), credential);

            var aoaiKey = client.GetSecret("aoaiapikey");
            var aoaiEndpoint = client.GetSecret("aoaiendpoint");


            var builder = new KernelBuilder();

            builder.WithAzureTextCompletionService(
                     "text-davinci-003",
                     aoaiEndpoint.Value.Value,
                     aoaiKey.Value.Value);

            var kernel = builder.Build();

            var pluginsDirectory = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "skills");

            var funPlugin = kernel.ImportSemanticFunctionsFromDirectory(pluginsDirectory, "FunSkill");

            var result = await kernel.RunAsync("time travel to dinosaur age", funPlugin["Joke"]);

            logger.LogInformation($"I heard a great joke from Azure OpenAI: {result.ToString()}");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString(result.ToString());

            return response;
        }
    }
}
