metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

var virtualNetworkName = '${customerName}-vnet'

@description('Location of the resources')
param location string = resourceGroup().location

@description('Virtual network address space prefix')
param virtualNetworkAddressSpacePrefix string 

@description('Application subnet prefix')
param appSubnetPrefix string

@description('Private endpoints subnet prefix')
param privateEndpointsSubnetPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressSpacePrefix
      ]
    }
  }
}

// Create subnets explicitly to refer to specific ones easier.
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
  dependsOn: [
    appSubnet
  ]
}

output virtualNetworkId string = virtualNetwork.id
output appSubnetId string = appSubnet.id
output privateEndpointsSubnetId string = privateEndpointsSubnet.id
output virtualNetworkName string = virtualNetwork.name
