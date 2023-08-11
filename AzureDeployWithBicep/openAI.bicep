metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

@description('Virtual Network ID for the private endpoint')
param virtualNetworkId string

@description('Subnet ID for the private endpoint NICs')
param subnetId string

var openAIName = '${customerName}-openai'

var location = resourceGroup().location

resource azureOpenAI 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAIName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: openAIName
    networkAcls: {
      defaultAction: 'Allow'
      ipRules: []
    }
    publicNetworkAccess: 'Disabled'
  }
}

// NOTE: this may fail if there is not enough capacity in the region. Also, hardcoding the model name, but it is not ideal.
resource deployment_text_davinci_003 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: azureOpenAI
  name: 'text-davinci-003'
  sku: {
    name: 'Standard'
    capacity: 60
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-davinci-003'
      version: '1'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    raiPolicyName: 'Microsoft.Default'
  }
}


var privateEndpointName = '${customerName}-openai-privateendpoint'
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: privateEndpointName
  location: location
  dependsOn: [
    // TODO: Remove if the NIC is removed
    // openAIPrivateEndpointNic
  ]
  properties: {
    subnet:{
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: azureOpenAI.id
          groupIds: [
            'account'
          ]
        }
      }
    ]
  }
}

var privateDnsZoneGroupsName = '${privateEndpointName}/default'
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = {
  name: privateDnsZoneGroupsName
  dependsOn: [
    privateEndpoint
  ]
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: openaiPrivateDnsZone.id
        }
      }
    ]
  }
}

var privateDnsZoneName = 'privatelink.openai.azure.com'
resource openaiPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  dependsOn: [
    azureOpenAI
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

var privateDnsZoneLinkName = '${customerName}-azureopenai-vnetlink'
resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: openaiPrivateDnsZone
  name: privateDnsZoneLinkName
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}


output azureOpenAiResourceId string = azureOpenAI.id
output azureOpenAIVersion string = azureOpenAI.apiVersion
output azureOpenAIEndpoint string = azureOpenAI.properties.endpoint
