using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.SemanticKernel;

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

var pluginsDirectory = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "skills");

// Load the FunSkill from the Skills Directory
var funPlugin = kernel.ImportSemanticFunctionsFromDirectory(pluginsDirectory, "FunSkill");

var result = await kernel.RunAsync("time travel to dinosaur age", funPlugin["Joke"]);

Console.WriteLine(result.ToString());