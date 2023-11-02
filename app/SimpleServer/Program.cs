
using Azure.Core;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.SemanticKernel;
using System;

namespace SimpleServer
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.MapGet("/joke", async (HttpContext httpContext, IConfiguration configuration) =>
            {
                var credential = new DefaultAzureCredential();

                var keyVaultEndpoint = configuration["KEYVAULTURI"];

                var client = new SecretClient(new Uri(keyVaultEndpoint), credential);

                var aoaiKey = client.GetSecret("aoaiapikey");
                var aoaiEndpoint = client.GetSecret("aoaiendpoint");
                Console.WriteLine(aoaiKey.Value.Value);

                var builder = new KernelBuilder();

                builder.WithAzureTextCompletionService(
                         "text-davinci-003",
                         aoaiEndpoint.Value.Value,
                         aoaiKey.Value.Value);

                var kernel = builder.Build();

                var skillsDirectory = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "skills");

                var funPlugin = kernel.ImportSemanticSkillFromDirectory(skillsDirectory, "FunSkill");

                var result = await kernel.RunAsync("time travel to dinosaur age", funPlugin["Joke"]);

                return result.ToString();
            });

            app.Run();
        }
    }
}