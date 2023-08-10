metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'subscription'

@description('Name of the customer')
param customerName string

@description('Location to create the resources in')
param location string

var resourceGroupName = '${customerName}-rg'
resource rgCustomer 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module networkingResources './networking.bicep' = {
  name: 'networkingResources'
  scope: rgCustomer
  params: {
    customerName: customerName
  }
}

module openAI './openAI.bicep' = {
  name: 'openAI'
  scope: rgCustomer
  params: {
    customerName: customerName
    virtualNetworkId: networkingResources.outputs.virtualNetworkId
    subnetId: networkingResources.outputs.privateEndpointsSubnetId
  }
  dependsOn: [
    networkingResources
  ]
}

module keyVault './keyVault.bicep' = {
  name: 'keyVault'
  scope: rgCustomer
  params: {
    customerName: customerName
    virtualNetworkId: networkingResources.outputs.virtualNetworkId
    subnetId: networkingResources.outputs.privateEndpointsSubnetId
    azureOpenAIResId: openAI.outputs.azureOpenAiResourceId
    azureOpenAIApiVersion: openAI.outputs.azureOpenAIVersion
    azureOpenAIEndpoint: openAI.outputs.azureOpenAIEndpoint
  }
  dependsOn: [
    networkingResources
    openAI
  ]
}

module virtualMachine './virtualMachine.bicep' = {
  name: 'virtualMachine'
  scope: rgCustomer
  params: {
    customerName: customerName
    subnetId: networkingResources.outputs.appSubnetId
    keyVaultUri: keyVault.outputs.keyVaultUri
  }
  dependsOn: [
    networkingResources
  ]
}
