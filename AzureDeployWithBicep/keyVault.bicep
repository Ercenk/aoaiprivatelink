metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

@description('Virtual Network ID for the private endpoint')
param virtualNetworkId string

@description('Subnet ID for the private endpoint NICs')
param subnetId string

@description('Resource ID for Azure OpenAI resource, this is used to get the API key.')
param azureOpenAIResId string

@description('API version used to create Azure OpenID resource, this is used to get the API key.')
param azureOpenAIApiVersion string

@description('Azure OpenAI endpoint')
param azureOpenAIEndpoint string

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

var azureOpenAIKeys = listKeys(azureOpenAIResId, azureOpenAIApiVersion)
resource aoaiapikey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'aoaiapikey'
  location: location
  properties: {
    attributes: {
      enabled: true
    }
    contentType: 'text/plain'
    value: azureOpenAIKeys.key1
  }
}

resource aoaiendpoint 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'aoaiendpoint'
  location: location
  properties: {
    attributes: {
      enabled: true
    }
    contentType: 'text/plain'
    value: azureOpenAIEndpoint
  }
}

var privateEndpointName = '${keyVaultName}-pe'
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}

var privateDnsZoneName = 'privatelink.vaultcore.azure.net'
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  dependsOn: [
    keyVault
  ]
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxnumberOfVirtualNetworkLinks: 1000
    maxnumberOfVirtualNetworkLinksWithRegistration: 100
    numberofrecordsets: 5
    numberOfVirtualNetworkLinks: 0
    numberOfVirtualNetworkLinksWithRegistration: 0
  }
}

var privateDnsZoneGroupName = '${privateEndpointName}/default'
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = {
  name: privateDnsZoneGroupName
  dependsOn: [
    privateEndpoint
  ]
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZone.id
        }
      }
    ]
  }
}

var privateDnsZoneLinkName = '${customerName}-key-vault-vnetlink'
resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: keyVaultPrivateDnsZone
  name: privateDnsZoneLinkName
  location: 'global'
  properties: {
    // Setting this fals, since Azure OpenAI one is true
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

output keyVaultName string = keyVaultName
output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
