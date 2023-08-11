metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer Virtual Network')
param customerVnetName string

@description('API management Virtual Network')
param apiManagementVnetName string = 'apim-vnet'
@description('Location of the resources')
param location string = resourceGroup().location

resource customerVnet 'Microsoft.Network/virtualNetworks@2023-04-01'  existing = {
  name: customerVnetName
}

// get the reference for the api management virtual network. If it were in a different subscription
//
// Example:
// assume subscription ID and Vnet names are paramaters
// resource apiManagementVnet =  'Microsoft.Network/virtualNetworks@2023-04-01'  existing = {
//   name: apiManagementVnetName
//   subscriptionId: subscription(customerSubscriptionId)

// Create the API management Vnet

resource apiManagementVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: apiManagementVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        // Notice the address space
        '10.1.0.0/16'
      ]
    }
  }
}



// Create peering from apiManagement to customer
var apiManagementToCustomerPeeringName = '${apiManagementVnet.name}/peer-to-${customerVnet.name}'
resource customerPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: apiManagementToCustomerPeeringName
  properties: {
    remoteVirtualNetwork: {
      id: customerVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

// Create peering from customer to apiManagement
var customerToApiManagementPeeringName = '${customerVnet.name}/peer-to-${apiManagementVnet.name}'
resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: customerToApiManagementPeeringName
  properties: {
    remoteVirtualNetwork: {
      id: apiManagementVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}
