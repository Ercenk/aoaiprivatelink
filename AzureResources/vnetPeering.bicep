metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'

@description('Tenant Virtual Network Name')
param tenantVnetName string

@description('Tenant Virtual Netowkr ID')
param tenantVnetId string

@description('APIM Resource Group Name')
param apimRgName string

@description('APIM Virtual Network Name')
param apimVnetName string

resource tenantVnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: tenantVnetName
}

var tenantVnetToApimVnetName = '${tenantVnetName}-to-${apimVnetName}'
var apimVnetId = resourceId(apimRgName, 'Microsoft.Network/virtualNetworks', apimVnetName)
resource tenantVnetToApimVnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: tenantVnetToApimVnetName
  parent: tenantVnet
  properties: {
    remoteVirtualNetwork: {
      id: apimVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource apimRg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  scope: subscription()
  name: apimRgName
}

module apimVnetToTenantVnetPeeringModule './apimVnetToTenantVnetPeering.bicep' = {
  name: 'apimVnetToTenantVnetPeeringModule'
  scope: apimRg
  params: {
    apimVnetName: apimVnetName
    tenantVnetName: tenantVnetName
    tenantVnetId: tenantVnetId
  }
}
