metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'subscription'

@description('Name of the customer')
param customerName string

@description('Location to create the resources in')
param location string

@description ('Public key for SSH access to the VM')
param sshPublicKey string = ''

@description('APIM Vnet resource group name')
param apimRgName string = 'apim-rg'

@description('APIM Vnet name')
param apimVnetName string = 'apim-vnet'

@description('Virtual network address space prefix')
param virtualNetworkAddressSpacePrefix string 

@description('Application subnet prefix')
param appSubnetPrefix string

@description('Private endpoints subnet prefix')
param privateEndpointsSubnetPrefix string

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
    location: location
    virtualNetworkAddressSpacePrefix: virtualNetworkAddressSpacePrefix
    appSubnetPrefix: appSubnetPrefix
    privateEndpointsSubnetPrefix: privateEndpointsSubnetPrefix
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

module virtualMachineModule './virtualMachine.bicep' = {
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
