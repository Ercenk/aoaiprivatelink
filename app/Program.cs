﻿using Azure.Core;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.SemanticKernel;

var credential = new DefaultAzureCredential();

var keyVaultEndpoint = "https://ercmscustakv.vault.azure.net";
var client = new SecretClient(new Uri(keyVaultEndpoint), credential); 

var aoaiKey = client.GetSecret("aoaiapikey");
var aoaiEndpoint = client.GetSecret("aoaiendpoint");

Console.WriteLine($"aoaiKey: {aoaiKey.Value.Value}, aoaiEndpoint: {aoaiEndpoint.Value.Value}");


var builder = new KernelBuilder();

builder.WithAzureChatCompletionService(
         "gpt-35-turbo",                 
         $"https://{aoaiEndpoint.Value.Value}",
         aoaiKey.Value.Value);  

var kernel = builder.Build();

var skillsDirectory = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "skills");

// Load the FunSkill from the Skills Directory
var funSkillFunctions = kernel.ImportSemanticSkillFromDirectory(skillsDirectory, "FunSkill");

var result = await funSkillFunctions["Joke"].InvokeAsync("time travel to dinosaur age");

// Return the result to the Notebook
Console.WriteLine(result);
