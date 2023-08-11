metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'subscription'

@description('Name of the customer')
param customerName string

@description('Location to create the resources in')
param location string

@description ('Public key for SSH access to the VM')
param sshPublicKey string = ''

var resourceGroupName = '${customerName}-rg'
resource rgCustomer 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module networkingResourcesModule './networking.bicep' = {
  name: 'networkingResourcesModule'
  scope: rgCustomer
  params: {
    customerName: customerName
  }
}

module openAIModule './openAI.bicep' = {
  name: 'openAIModule'
  scope: rgCustomer
  params: {
    customerName: customerName
    virtualNetworkId: networkingResourcesModule.outputs.virtualNetworkId
    subnetId: networkingResourcesModule.outputs.privateEndpointsSubnetId
  }
  dependsOn: [
    networkingResourcesModule
  ]
}

module keyVaultModule './keyVault.bicep' = {
  name: 'keyVault'
  scope: rgCustomer
  params: {
    customerName: customerName
    virtualNetworkId: networkingResourcesModule.outputs.virtualNetworkId
    subnetId: networkingResourcesModule.outputs.privateEndpointsSubnetId
    azureOpenAIResId: openAIModule.outputs.azureOpenAiResourceId
    azureOpenAIApiVersion: openAIModule.outputs.azureOpenAIVersion
    azureOpenAIEndpoint: openAIModule.outputs.azureOpenAIEndpoint
  }
  dependsOn: [
    networkingResourcesModule
    openAIModule
  ]
}

module virtualMachine './virtualMachine.bicep' = {
  name: 'virtualMachine'
  scope: rgCustomer
  params: {
    customerName: customerName
    subnetId: networkingResourcesModule.outputs.appSubnetId
    sshPublicKey: sshPublicKey
    keyVaultUri: keyVaultModule.outputs.keyVaultUri
    keyVaultName: keyVaultModule.outputs.keyVaultName
  }
  dependsOn: [
    networkingResourcesModule
  ]
}

