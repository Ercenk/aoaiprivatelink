metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

var keyVaultName = '${customerName}-kv'

var location = resourceGroup().location

var vaultUri = 'https://${keyVaultName}.vault.azure.net'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    publicNetworkAccess: 'Disabled'
    vaultUri: vaultUri
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
 }
}

output keyVaultId string = keyVault.id
