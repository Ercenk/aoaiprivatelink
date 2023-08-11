metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

var virtualNetworkName = '${customerName}-vnet'

@description('Location of the resources')
param location string = resourceGroup().location

var appSubnetPrefix = '10.0.0.0/24'
var privateEndpointsSubnetPrefix = '10.0.1.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'app'
  parent: virtualNetwork
  properties: {
    addressPrefix: appSubnetPrefix
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource privateEndpointsSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'privateEndpoints'
  parent: virtualNetwork
  properties: {
    addressPrefix: privateEndpointsSubnetPrefix
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

module apiManagementWithVnet './apiManagementWithVnet.bicep' = {
  name: 'apiManagementWithVnet'
  params: {
    customerVnetName: virtualNetwork.name
    customerVnetApiVersion: virtualNetwork.apiVersion
    location: location
  }
  dependsOn: [
    virtualNetwork
  ]
}


output virtualNetworkId string = virtualNetwork.id
output appSubnetId string = appSubnet.id
output privateEndpointsSubnetId string = privateEndpointsSubnet.id
