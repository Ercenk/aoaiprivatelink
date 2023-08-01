metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Name of the resourceGroup to create the resources in')
param rgName string

var rgLocation = resourceGroup().location

module virtualNetwork 'networking.bicep' = {
  name: 'virtualNetwork'
  params: {
    rgName: rgName
    location: rgLocation
  }
}

module openAi 'openAI.bicep' = {
  name: 'openAi'
  params: {
    rgName: rgName
    location: rgLocation
  }
}




