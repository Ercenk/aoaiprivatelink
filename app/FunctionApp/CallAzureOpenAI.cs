using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace Contoso.AzureOpenAI
{
    public class CallAzureOpenAI
    {
        private readonly ILogger _logger;

        public CallAzureOpenAI(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<CallAzureOpenAI>();
        }

        [Function("CallAzureOpenAI")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req)
        {
            var credential = new DefaultAzureCredential();

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

            var skillsDirectory = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "skills");

            // Load the FunSkill from the Skills Directory
            var funSkillFunctions = kernel.ImportSemanticSkillFromDirectory(skillsDirectory, "FunSkill");

            var result = await funSkillFunctions["Joke"].InvokeAsync("time travel to dinosaur age");

            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString(result);

            return response;
        }
    }
}
