using System.Net;
using JokeService;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Contoso.JokeTeller
{
    public class TellMeAJoke
    {
        private readonly ILogger logger;
        private readonly IJokeMachine jokeMachine;

        public TellMeAJoke(IJokeMachine jokeMachine, ILoggerFactory loggerFactory)
        {
            this.logger = loggerFactory.CreateLogger<TellMeAJoke>();
            this.jokeMachine = jokeMachine;
        }

        [Function("TellMeAJoke")]
        public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequestData req)
        {
            var jokeSubject = req.Query["tellMeAJokeAbout"];

            if (jokeSubject == default)
            {
                this.logger.LogError("Cannot find a url parameter with name tellMeAJokeAbout");
                return req.CreateResponse(HttpStatusCode.NotFound);
            }
            var joke = await this.jokeMachine.TellJokeAsync(jokeSubject);

            logger.LogInformation($"I heard a great joke from Azure OpenAI: {joke}");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString(joke);

            return response;
        }
    }
}
