
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Connectors.AI.OpenAI;

namespace JokeService;

public class JokeMachine : IJokeMachine
{
    private Kernel kernel;
    private OpenAIPromptExecutionSettings executionSettings;

    public JokeMachine(IConfiguration configuration)
    {
        var credential = new DefaultAzureCredential(true);

        var keyVaultUri = "KEYVAULTURI";
        var keyVaultEndpoint = GetSetting(configuration, keyVaultUri);

        var deploymentVariableName = "OPENAI_DEPLOYMENT_NAME";
        var aoaiDeploymentName = GetSetting(configuration, deploymentVariableName);

        var modelIdName = "OPENAI_MODEL_ID";
        var modelId = GetSetting(configuration, modelIdName);

        var client = new SecretClient(new Uri(keyVaultEndpoint), credential);

        var aoaiKey = client.GetSecret("aoaiapikey").Value.Value;
        var aoaiEndpoint = client.GetSecret("aoaiendpoint").Value.Value;

        if (string.IsNullOrEmpty(aoaiKey))
        {
            throw new Exception($"Secret {aoaiKey} is not set.");
        }

        if (string.IsNullOrEmpty(aoaiEndpoint))
        {
            throw new Exception($"Secret {aoaiEndpoint} is not set.");
        }

        var builder = new KernelBuilder()
            .WithLoggerFactory(LoggerFactory.Create(builder =>
                builder
                .AddConsole()
                .SetMinimumLevel(LogLevel.Information))
                )
            .WithAzureOpenAITextGeneration(
                 aoaiDeploymentName,
                 modelId,
                 aoaiEndpoint,
                 aoaiKey);

        this.kernel = builder.Build();

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

    public JokeMachine(string deploymentName, string modelId, string aoaiEndpoint, string aoaiKey)
    {
        var builder = new KernelBuilder()
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

        this.kernel = builder.Build();

        this.executionSettings = new OpenAIPromptExecutionSettings()
        {
            MaxTokens = 100,
            Temperature = 0.7,
            TopP = 1.0,
            FrequencyPenalty = 0.0,
            PresencePenalty = 0.0,
        };
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
