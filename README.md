# Multi-tenant deployment for Azure OpenAI using separate subscriptions, or resource groups per tenant

A recent sample describing how to implement [logging and monitoring Azure OpenAI models](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/ai/log-monitor-azure-openai) also shows how a Azure Private Endpoints can limit access to an Azure OpenAI service. 

This sample takes the sample mentioned before one step further to describe how Private Endpoints and tenant specific Azure Subscriptions, or resource groups can provide a multi-tenant approach for a solution using Azure OpenAI.

At the high level, there is a subscription or a resource group that exposes an endpoint to external clients through an Azure API Management instance, which in turn accesses a service exposed on tenant specific Azure subscription or resource group, that hides the underlying Azure OpenAI service, while securing it at multiple levels.

![high level design](./Assets/Exposing%20Azure%20OpenAI%20service/Slide3.PNG)

## Points of security

The goal of this design is to provide multiple layers of security

1. A next generation firewall offers features like TLS inspection, intrusion detection and prevention system (IDPS), web categories and URL filtering
2. Azure API Management provides security features such as authentication through Oauth 2.0 and OpenID Connect, authorization through policies, and API keys, encryption through TLS, validation, logging and monitoring.
3. Virtual Network peering between API endpoint Virtual Network and tenant specific Virtual networks allows Network Security Groups (NSGs) to control inbound and outbound traffic flow
4. NSGs between app and private endpoint subnets in the tenant VNET
5. Managed Identity the compute resources runs under to access the secrets in Azure Key Vault
6. Azure OpenAI key and endpoint are kept as secrets in

## Details 
The [AzureDeploy folder's bicep files](https://github.com/Azure-Samples/openai-apim/tree/main/AzureDeploy) deploy several Azure resources to demonstrate the concept.

The [main.bicep file](https://github.com/Azure-Samples/openai-apim/blob/main/AzureDeploy/main.bicep) deploys the following resources in order:

* Create a resource group for the tenant
* Create virtual network and two subnets, one for the code, the other for private endpoints
* Create Azure OpenAI resource, private endpoint for the resource, and relevant DNS settings
* Create Azure Key Vault to keep Azure OpenAI account API key and endpoint URL, set those secrets, create private endpoint and relevant DNS settings
* Create an Azure Virtual Machine to host the code that will run under a Managed Identity, place the VM on the app subnet, add the VMS managed identity to the built-in "Key Vault Secrets User" role 
* Create peering between the Azure API Management Virtual Network and tenant's Virtual Network. The bicep file calls another module to deploy the corresponding peering for the reverse order. You do not need to do this if creating a peering from Azure portal. 

The VM is the easiest option to demonstrate the concept. An alternative to the VM can be an Azure Container Instance. Instead of using multiple subscriptions, two VNETs are used to demonstrate the concept. One VNET represents the Azure subscription that contains the APIM instance, and the other is for the tenant. The bicep files deploy tenant resources but assume a VNET with APIM deployed already. Please ensure that address spaces of VNETs do not overlap.

![Tenant resource group details](./Assets/Exposing%20Azure%20OpenAI%20service/Slide2.PNG)

## Setting up the Azure API Management front-end environment

Create a resource group representing main subscription

Firstly, log in to Azure

```sh
az login
```

In case of access to multiple Azure subscriptions, select the subscription.

```sh
az account set --subscription "<subscription_id>"
```

Create a resource group for the API Management endpoint.
```sh
az group create --location eastus --resource-group apim-rg
```

Create a virtual network in the new resource group. Notice the address space created which will not overlap with the virtual network for the tenant’s.
```sh
az network vnet create \
  --resource-group apim-rg \
  --name apim-vnet \
  --address-prefixes 10.1.0.0/16 \
  --subnet-name default \
  --subnet-prefixes 10.1.1.0/24
```
Add an API management service on that virtual network using the included ```apiManagementWithVnet.bicep```  file. Note that the generated APIM resource is a random name to avoid clashes with other instances. This step may take a while.

```sh
az deployment group create \
  --name "apimdeployment" \
  --resource-group apim-rg \
  --template-file apiManagementWithVnet.bicep
```

## Deploying an environment for a tenant

