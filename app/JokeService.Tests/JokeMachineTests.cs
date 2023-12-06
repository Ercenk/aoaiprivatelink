using Microsoft.Extensions.Configuration;

using Xunit.Abstractions;

namespace JokeService.Tests;

public class JokeMachineTests
{
    private readonly ITestOutputHelper output;
    private IConfigurationRoot configuration;

    public JokeMachineTests(ITestOutputHelper output)
    {
        this.configuration = new ConfigurationBuilder()
          .AddUserSecrets<JokeMachineTests>()
          .Build();
        this.output = output;
    }
    [Fact]
    public async Task CanTellJoke()
    {
        var aoaiEndpoint = this.configuration["aoiEndpoint"];
        var aoaiKey = this.configuration["aoaiKey"];
        var deploymentName = this.configuration["deploymentName"];
        var modelId = this.configuration["OPENAI_MODEL_ID"];

        if (string.IsNullOrEmpty(aoaiEndpoint))
        {
            throw new ArgumentNullException("aoaiEndpoint");
        }

        if (string.IsNullOrEmpty(aoaiKey))
        {
            throw new ArgumentNullException("aoaiKey");
        }

        if (string.IsNullOrEmpty(deploymentName))
        {
            throw new ArgumentNullException("deploymentName");
        }

        var jokeMachine = new JokeMachine(deploymentName, modelId, aoaiEndpoint, aoaiKey);

        var jokeTopic = "random joke";
        var joke = await jokeMachine.TellJokeAsync(jokeTopic);

        Assert.NotNull(joke);

        Assert.NotEmpty(joke);
    }

    [Fact]
    public async Task CanTellIfFunny()
    {
        var aoaiEndpoint = this.configuration["aoiEndpoint"];
        var aoaiKey = this.configuration["aoaiKey"];
        var deploymentName = this.configuration["deploymentName"];
        var modelId = this.configuration["OPENAI_MODEL_ID"];

        if (string.IsNullOrEmpty(aoaiEndpoint))
        {
            throw new ArgumentNullException("aoaiEndpoint");
        }

        if (string.IsNullOrEmpty(aoaiKey))
        {
            throw new ArgumentNullException("aoaiKey");
        }

        if (string.IsNullOrEmpty(deploymentName))
        {
            throw new ArgumentNullException("deploymentName");
        }

        var jokeMachine = new JokeMachine(deploymentName, modelId, aoaiEndpoint, aoaiKey);

        var jokeTopic = "random joke";
        var joke = await jokeMachine.TellJokeAsync(jokeTopic);

        Assert.NotNull(joke);

        Assert.NotEmpty(joke);

        var isFunny = await jokeMachine.IsThisFunnyAsync(joke);

        Assert.NotNull(isFunny);

        Assert.NotEmpty(isFunny);
    }
}