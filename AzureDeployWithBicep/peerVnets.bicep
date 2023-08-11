metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer Vnet resource group name')
param customerVnetRgName string

@description('Name of the customer virtual network')
param customerVnetName string

@description('API Vnet resource group name')
param apimVnetRgName string

@description('Name of the APIM virtual network')
param apimVnetName string

resource customerRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: customerVnetRgName
}

resource apimRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: apimVnetRgName
}

resource customerVnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  scope: customerRg
  name: customerVnetName
}

resource apimVnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  scope: apimRg
  name: apimVnetName
}

// Create peering from customer vnet to APIM vnet
var custVnetToApimVnetName = '${customerVnet.name}/peer-to-${apimVnet.name}'
resource custVnetToApimVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: custVnetToApimVnetName
  properties: {
    remoteVirtualNetwork: {
      id: apimVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

