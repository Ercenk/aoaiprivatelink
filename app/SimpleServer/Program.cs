
using JokeService;

using Microsoft.AspNetCore.Mvc;

namespace SimpleServer
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddSingleton<IJokeMachine, JokeMachine>();

            var app = builder.Build();

            app.MapGet("/api/joke", async ([FromQuery] string tellMeAJokeAbout, IJokeMachine jokeMachine, HttpContext httpContext, IConfiguration configuration) =>
            {
                var joke = await jokeMachine.TellJokeAsync(tellMeAJokeAbout);

                return joke;
            });

            app.Run();
        }
    }
}