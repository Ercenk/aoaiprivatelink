metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Tenant Virtual Network Name')
param tenantVnetName string

@description('Tenant Virtual Netowkr ID')
param tenantVnetId string

// @description('APIM Resource Group Name')
// param apimRgName string

@description('APIM Virtual Network Name')
param apimVnetName string

var apimVnetNameToTenantVnetName = '${apimVnetName}/${apimVnetName}-to-${tenantVnetName}'
resource apimVnetNameToTenantVnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: apimVnetNameToTenantVnetName
  properties: {
    remoteVirtualNetwork: {
      id: tenantVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
