metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Name of the resourceGroup to create the resources in')
param rgName string

@description('Name of the location to create the resources in')
param location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'name'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'privateEndpoints'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'app'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
