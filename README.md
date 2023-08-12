# Multi-tenant deployment for Azure OpenAI using separate subscriptions per tenant

Describe multi-tenant deployment, each customer is in a different subscription, and vnet, 

## Setting up the Azure API Management front end environment


Create a resource group representing main subscription

First login to Azure

```sh
az login
```

In case you have access to multiple subscriptions, select your subscription.

```sh
az account set --subscription "<subscription_id>"
```

Now create a resource group representing the main subscription.
```sh
az group create --location eastus --resource-group apim-rg
```

We will not create a virtual network in the new resource group. Notice the address space we are creating which will not clash with the virtual network for the tenant's
```sh
az network vnet create \
  --resource-group apim-rg \
  --name apim-vnet \
  --address-prefixes 10.1.0.0/16 \
  --subnet-name default \
  --subnet-prefixes 10.1.1.0/24
```
Now we will add a API management service on that virtual network. We will use the included ```apiManagementWithVnet.bicep``` file. Please note the generated APIM resource is a random name to avoid clashes with other instances. This step may take a while.
```sh
az deployment group create \
  --name "apimdeployment" \
  --resource-group apim-rg \
  --template-file apiManagementWithVnet.bicep
```