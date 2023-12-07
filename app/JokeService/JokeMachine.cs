using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Connectors.AI.OpenAI;

namespace JokeService;

public class JokeMachine : IJokeMachine
{
    private Kernel? kernel;
    private OpenAIPromptExecutionSettings? executionSettings;

    /// <summary>
    /// Initializes a new instance of the <see cref="JokeMachine"/> class.
    /// </summary>
    /// <param name="configuration">The configuration object used to retrieve settings.</param>
    public JokeMachine(IConfiguration configuration)
    {
        var credential = new DefaultAzureCredential();

        var kernelBuilder = new KernelBuilder()
            .WithLoggerFactory(LoggerFactory.Create(builder =>
                builder
                .AddConsole()
                .SetMinimumLevel(LogLevel.Information))
                );

        var deploymentVariableName = "OPENAI_DEPLOYMENT_NAME";
        var aoaiDeploymentName = GetSetting(configuration, deploymentVariableName);

        var modelIdName = "OPENAI_MODEL_ID";
        var modelId = GetSetting(configuration, modelIdName);

        var useAzureCredsName = "USEAZURECREDS";
        var useAzureCreds = GetSetting(configuration, useAzureCredsName);

        var keyVaultUri = "KEYVAULTURI";
        var keyVaultEndpoint = GetSetting(configuration, keyVaultUri);

        var secretsClient = new SecretClient(new Uri(keyVaultEndpoint), credential);
        var aoaiEndpoint = secretsClient.GetSecret("aoaiendpoint").Value.Value;

        if (string.IsNullOrEmpty(aoaiEndpoint))
        {
            throw new Exception($"Secret {aoaiEndpoint} is not set.");
        }

        if (useAzureCreds != "true")
        {
            var aoaiKey = secretsClient.GetSecret("aoaiapikey").Value.Value;

            if (string.IsNullOrEmpty(aoaiKey))
            {
                throw new Exception($"Secret {aoaiKey} is not set.");
            }

            kernelBuilder.WithAzureOpenAITextGeneration(
                     aoaiDeploymentName,
                     modelId,
                     aoaiEndpoint,
                     aoaiKey);
        }
        else
        {
            kernelBuilder.WithAzureOpenAITextGeneration(
                 aoaiDeploymentName,
                 modelId,
                 aoaiEndpoint,
                 credential);
        }

        this.kernel = kernelBuilder.Build();

        this.executionSettings = new OpenAIPromptExecutionSettings()
        {
            MaxTokens = 100,
            Temperature = 0.7,
            TopP = 1.0,
            FrequencyPenalty = 0.0,
            PresencePenalty = 0.0,
        };
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="JokeMachine"/> class.
    /// </summary>
    /// <param name="deploymentName">The name of the deployment.</param>
    /// <param name="modelId">The ID of the model.</param>
    /// <param name="aoaiEndpoint">The endpoint for Azure OpenAI Private Link.</param>
    /// <param name="aoaiKey">The key for Azure OpenAI Private Link.</param>
    public JokeMachine(string deploymentName, string modelId, string aoaiEndpoint, string aoaiKey)
    {
        var kernelBuilder = new KernelBuilder()
            .WithLoggerFactory(LoggerFactory.Create(builder =>
                builder
                .AddConsole()
                .SetMinimumLevel(LogLevel.Information))
            )
            .WithAzureOpenAITextGeneration(
                deploymentName,
                modelId,
                aoaiEndpoint,
                aoaiKey);

        this.kernel = kernelBuilder.Build();

        this.executionSettings = new OpenAIPromptExecutionSettings()
        {
            MaxTokens = 100,
            Temperature = 0.7,
            TopP = 1.0,
            FrequencyPenalty = 0.0,
            PresencePenalty = 0.0,
        };
    }

    private static string GetSetting(IConfiguration configuration, string variableName)
    {
        var keyVaultEndpoint = configuration[variableName];

        if (string.IsNullOrEmpty(keyVaultEndpoint))
        {
            throw new Exception($"Setting {variableName} is not set.");
        }

        return keyVaultEndpoint;
    }


    public async Task<string> TellJokeAsync(string input)
    {
        var prompt = @"
WRITE EXACTLY ONE JOKE or HUMOROUS STORY ABOUT THE TOPIC BELOW

JOKE MUST BE:
- G RATED
- WORKPLACE/FAMILY SAFE
NO SEXISM, RACISM OR OTHER BIAS/BIGOTRY

BE CREATIVE AND FUNNY. I WANT TO LAUGH.
+++++

{{$input}}
+++++
        ";


        return await GetCompletionAsync(prompt, input);
    }

    public async Task<string> IsThisFunnyAsync(string input)
    {
        var prompt = @"
Let me know if the following text is funny or not. 
You should answer ""YES"", ""NO"" or ""ICANNOTTELL"".

[INPUT]
{{$input}}
[END INPUT]
";
        return await GetCompletionAsync(prompt, input);
    }

    private async Task<string> GetCompletionAsync(string prompt, string input)
    {
        var jokeFunction = this.kernel.CreateFunctionFromPrompt(prompt, this.executionSettings);

        var result = await this.kernel.InvokeAsync(jokeFunction, new KernelArguments() { { "input", input } });

        return result.ToString();
    }
}
