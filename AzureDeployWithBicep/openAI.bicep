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

// Capacity is changing, remove automatic deployment for now.
// resource deployment_text_davinci_003 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
//   parent: azureOpenAI
//   name: 'text-davinci-003'
//   sku: {
//     name: 'Standard'
//     capacity: 60
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'text-davinci-003'
//       version: '1'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     raiPolicyName: 'Microsoft.Default'
//   }
// }

// TODO: maybe created automatically, and remove?
// var openAIPrivateEndpointNicName = '${customerName}-openai-nic'
// var openAIPrivateEndpointNicIpConfigName = '${openAIPrivateEndpointNicName}-${uniqueString(resourceGroup().id)}'
// TODO: But keep this if we are keeping the reference below
var openAiFqdn = '${customerName}-aoai.openai.azure.com'
// resource openAIPrivateEndpointNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
//   name: openAIPrivateEndpointNicName
//   location: location
//   kind: 'Regular'
//   properties: {
//     ipConfigurations: [
//       {
//         name: openAIPrivateEndpointNicIpConfigName
//         type: 'Microsoft.Network/networkInterfaces/ipConfigurations@2023-04-01'
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           subnet: {
//             id: subnetId
//           }
//           primary: true
//           privateIPAddressVersion: 'IPv4'
//           privatelinkConnectionProperties: {
//             groupId: 'account'
//             requiredMemberName: 'default'
//             fqdns: [
//               openAiFqdn
//             ]
//           }
//         }
//       }
//     ]
//     dnsSettings: {
//       dnsServers: []
//     }
//     enableAcceleratedNetworking: false
//     enableIPForwarding: false
//     disableTcpStateTracking: false
//     nicType: 'Standard'
//   }
// }

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

// TODO: Maybe remove this?
// var openAIPrivateEndpointConnectionName = '${customerName}-${uniqueString(resourceGroup().id)}'
// resource openaiPrivateEndpointConnection 'Microsoft.CognitiveServices/accounts/privateEndpointConnections@2023-05-01' = {
//   parent: azureOpenAI
//   name: openAIPrivateEndpointConnectionName
//   location: location
//   properties:{
//     privateEndpoint: {
//       id: openAIPrivateEndpointNic.id
//     }
//     groupIds: [
//       'account'
//     ]
//     privateLinkServiceConnectionState: {
//       status: 'Approved'
//       description: 'Approved by customer'
//       actionsRequired: 'None'
//     }
//   }
// }

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

// TODO: Shall I remove this one too?
// var privateEndpointDnsGroupName = '${privateEndpointName}/aoaigroup'
// resource privateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = {
//   name: privateEndpointDnsGroupName
//   dependsOn: [
//     privateEndpoint
//   ]
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: privateDnsZoneName
//         properties: {
//           privateDnsZoneId: openaiPrivateDnsZone.id
//         }
//       }
//     ]
//   }
// }

// var virtualNetworkLinkName = '${customerName}-azureopenai-vnetlink/${uniqueString(resourceGroup().id)}'
// resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
//   name: virtualNetworkLinkName
//   parent
//   location: 'global'
//   dependsOn:[
//     openaiPrivateDnsZone
//     openAIPrivateEndpointNic
//   ]
//   properties: {
//     registrationEnabled: true
//     virtualNetwork: {
//       id: openAIPrivateEndpointNic.properties.ipConfigurations[0].properties.subnet.properties.virtualNetwork.id
//     }
//   }
// }

// var azureOpenAIPrivateLinkDomainName = 'privatelink.openai.azure.com'

// var privateDnsZoneARecordName = '${azureOpenAIPrivateLinkDomainName}/${openAiFqdn}'
// resource openaiPrivateDnsZoneARecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
//   dependsOn: [
//     // TODO: Remove the following when removing NIC
//     // openAIPrivateEndpointNic
//     openaiPrivateDnsZone
//   ]
//   name: privateDnsZoneARecordName
//   location: 'global'
//   properties: {
//   }
// }


// TODO: Remove following too?
// var privateDnsZoneSOARecordName = '${azureOpenAIPrivateLinkDomainName}/@'
// resource privateDnsZoneSOARecord 'Microsoft.Network/privateDnsZones/SOA@2020-06-01' = {
//   name: privateDnsZoneSOARecordName
//   dependsOn: [
//     openaiPrivateDnsZone
//   ]
//   properties: {
//     ttl: 3600
//     soaRecord: {
//       email: 'azureprivatedns-host.microsoft.com'
//       expireTime: 3600
//       host: 'azureprivatedns.net'
//       minimumTTL: 10
//       refreshTime: 3600
//       retryTime: 300
//       serialNumber: 1
//     }
//   }
// }



output azureOpenAiResourceId string = azureOpenAI.id
output azureOpenAIVersion string = azureOpenAI.apiVersion
output azureOpenAIEndpoint string = azureOpenAI.properties.endpoint
