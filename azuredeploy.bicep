param vaults_ercmscustakv_name string = 'ercmscustakv'
param privateEndpoints_kvep_name string = 'kvep'
param privateEndpoints_custaoaipe_name string = 'custaoaipe'
param virtualNetworks_oaicustomera_name string = 'oaicustomera'
param networkInterfaces_custaoaipe_nic_name string = 'custaoaipe-nic'
param accounts_custaaoaiprivate_name string = 'custaaoaiprivate'
param privateEndpoints_aoaiprivateendpoint_name string = 'aoaiprivateendpoint'
param privateDnsZones_privatelink_openai_azure_com_name string = 'privatelink.openai.azure.com'
param privateDnsZones_privatelink_vaultcore_azure_net_name string = 'privatelink.vaultcore.azure.net'
param networkInterfaces_kvep_nic_ca130abb_46ea_4b1b_8dd5_99d95af70b0c_name string = 'kvep.nic.ca130abb-46ea-4b1b-8dd5-99d95af70b0c'
param networkInterfaces_aoaiprivateendpoint_nic_8f7e80f0_3d71_46f3_abfb_6a9396869bef_name string = 'aoaiprivateendpoint.nic.8f7e80f0-3d71-46f3-abfb-6a9396869bef'

resource accounts_custaaoaiprivate_name_resource 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: accounts_custaaoaiprivate_name
  location: 'eastus2'
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: accounts_custaaoaiprivate_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Disabled'
  }
}

resource vaults_ercmscustakv_name_resource 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: vaults_ercmscustakv_name
  location: 'eastus2'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '16b3c013-d300-468d-ac64-7eda0820b6d3'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    vaultUri: 'https://${vaults_ercmscustakv_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Disabled'
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_openai_azure_com_name
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
    numberOfRecordSets: 2
    numberOfVirtualNetworkLinks: 0
    numberOfVirtualNetworkLinksWithRegistration: 0
    provisioningState: 'Succeeded'
  }
}

resource privateDnsZones_privatelink_vaultcore_azure_net_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_vaultcore_azure_net_name
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
    numberOfRecordSets: 2
    numberOfVirtualNetworkLinks: 0
    numberOfVirtualNetworkLinksWithRegistration: 0
    provisioningState: 'Succeeded'
  }
}

resource virtualNetworks_oaicustomera_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: virtualNetworks_oaicustomera_name
  location: 'eastus2'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_oaicustomera_name_default.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'app'
        id: virtualNetworks_oaicustomera_name_app.id
        properties: {
          addressPrefix: '10.0.1.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
            {
              service: 'Microsoft.CognitiveServices'
              locations: [
                '*'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'privateEndpoints'
        id: virtualNetworks_oaicustomera_name_privateEndpoints.id
        properties: {
          addressPrefix: '10.0.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource accounts_custaaoaiprivate_name_custaoaipe_e10d4db9_3631_4dd0_a952_b10ef4d2fda2 'Microsoft.CognitiveServices/accounts/privateEndpointConnections@2023-05-01' = {
  parent: accounts_custaaoaiprivate_name_resource
  name: 'custaoaipe.e10d4db9-3631-4dd0-a952-b10ef4d2fda2'
  location: 'eastus2'
  properties: {
    privateEndpoint: {}
    groupIds: [
      'account'
    ]
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Approved'
      actionsRequired: 'None'
    }
    provisioningState: 'Succeeded'
  }
}

resource vaults_ercmscustakv_name_kvep_83590ab0_b2b6_4381_bd31_ba4aac9e61e0 'Microsoft.KeyVault/vaults/privateEndpointConnections@2023-02-01' = {
  parent: vaults_ercmscustakv_name_resource
  name: 'kvep_83590ab0-b2b6-4381-bd31-ba4aac9e61e0'
  location: 'eastus2'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      actionsRequired: 'None'
    }
  }
}

resource networkInterfaces_aoaiprivateendpoint_nic_8f7e80f0_3d71_46f3_abfb_6a9396869bef_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_aoaiprivateendpoint_nic_8f7e80f0_3d71_46f3_abfb_6a9396869bef_name
  location: 'eastus2'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.3e46df2c-4a0a-4768-8184-0536fbd2dba1'
        id: '${networkInterfaces_aoaiprivateendpoint_nic_8f7e80f0_3d71_46f3_abfb_6a9396869bef_name_resource.id}/ipConfigurations/privateEndpointIpConfig.3e46df2c-4a0a-4768-8184-0536fbd2dba1'
        etag: 'W/"dc857d62-01b5-4502-9dd9-1267a1f37810"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_oaicustomera_name_privateEndpoints.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateLinkConnectionProperties: {
            groupId: 'account'
            requiredMemberName: 'default'
            fqdns: []
          }
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

resource networkInterfaces_custaoaipe_nic_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_custaoaipe_nic_name
  location: 'eastus2'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.9f0b3c3b-1737-4777-ac03-ffcfab65cd9d'
        id: '${networkInterfaces_custaoaipe_nic_name_resource.id}/ipConfigurations/privateEndpointIpConfig.9f0b3c3b-1737-4777-ac03-ffcfab65cd9d'
        etag: 'W/"4f1ee6be-e7f5-42e4-ae89-1701c884b7ec"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.2.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_oaicustomera_name_privateEndpoints.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateLinkConnectionProperties: {
            groupId: 'account'
            requiredMemberName: 'default'
            fqdns: [
              'custaaoaiprivate.openai.azure.com'
            ]
          }
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

resource networkInterfaces_kvep_nic_ca130abb_46ea_4b1b_8dd5_99d95af70b0c_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_kvep_nic_ca130abb_46ea_4b1b_8dd5_99d95af70b0c_name
  location: 'eastus2'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.16728cd2-cfb6-4c3e-a2f3-7194b462a694'
        id: '${networkInterfaces_kvep_nic_ca130abb_46ea_4b1b_8dd5_99d95af70b0c_name_resource.id}/ipConfigurations/privateEndpointIpConfig.16728cd2-cfb6-4c3e-a2f3-7194b462a694'
        etag: 'W/"2afbbdee-4aa6-450b-b124-dc52a1900698"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.2.6'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_oaicustomera_name_privateEndpoints.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateLinkConnectionProperties: {
            groupId: 'vault'
            requiredMemberName: 'default'
            fqdns: [
              'ercmscustakv.vault.azure.net'
            ]
          }
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_custaaoaiprivate 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'custaaoaiprivate'
  properties: {
    metadata: {
      creator: 'created by private endpoint custaoaipe with resource guid e10d4db9-3631-4dd0-a952-b10ef4d2fda2'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.2.5'
      }
    ]
  }
}

resource privateDnsZones_privatelink_vaultcore_azure_net_name_ercmscustakv 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_vaultcore_azure_net_name_resource
  name: 'ercmscustakv'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.0.2.6'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_openai_azure_com_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_vaultcore_azure_net_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_privatelink_vaultcore_azure_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_oaicustomera_name_app 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_oaicustomera_name}/app'
  properties: {
    addressPrefix: '10.0.1.0/24'
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.CognitiveServices'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_oaicustomera_name_resource
  ]
}

resource virtualNetworks_oaicustomera_name_default 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_oaicustomera_name}/default'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_oaicustomera_name_resource
  ]
}

resource virtualNetworks_oaicustomera_name_privateEndpoints 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_oaicustomera_name}/privateEndpoints'
  properties: {
    addressPrefix: '10.0.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_oaicustomera_name_resource
  ]
}

resource privateDnsZones_privatelink_openai_azure_com_name_7w3qzsxgr6grw 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: '7w3qzsxgr6grw'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_oaicustomera_name_resource.id
    }
  }
}

resource privateDnsZones_privatelink_vaultcore_azure_net_name_7w3qzsxgr6grw 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_vaultcore_azure_net_name_resource
  name: '7w3qzsxgr6grw'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_oaicustomera_name_resource.id
    }
  }
}

resource privateEndpoints_aoaiprivateendpoint_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: privateEndpoints_aoaiprivateendpoint_name
  location: 'eastus2'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_aoaiprivateendpoint_name
        id: '${privateEndpoints_aoaiprivateendpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_aoaiprivateendpoint_name}'
        properties: {
          privateLinkServiceId: accounts_custaaoaiprivate_name_resource.id
          groupIds: [
            'account'
          ]
          privateLinkServiceConnectionState: {
            status: 'Disconnected'
            description: 'connection deleted'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_oaicustomera_name_privateEndpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_custaoaipe_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: privateEndpoints_custaoaipe_name
  location: 'eastus2'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_custaoaipe_name
        id: '${privateEndpoints_custaoaipe_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_custaoaipe_name}'
        properties: {
          privateLinkServiceId: accounts_custaaoaiprivate_name_resource.id
          groupIds: [
            'account'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_custaoaipe_name}-nic'
    subnet: {
      id: virtualNetworks_oaicustomera_name_privateEndpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_kvep_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: privateEndpoints_kvep_name
  location: 'eastus2'
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoints_kvep_name}_83590ab0-b2b6-4381-bd31-ba4aac9e61e0'
        id: '${privateEndpoints_kvep_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_kvep_name}_83590ab0-b2b6-4381-bd31-ba4aac9e61e0'
        properties: {
          privateLinkServiceId: vaults_ercmscustakv_name_resource.id
          groupIds: [
            'vault'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_oaicustomera_name_privateEndpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: 'ercmscustakv.vault.azure.net'
        ipAddresses: [
          '10.0.2.6'
        ]
      }
    ]
  }
}

resource privateEndpoints_custaoaipe_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = {
  name: '${privateEndpoints_custaoaipe_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-openai-azure-com'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_openai_azure_com_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_custaoaipe_name_resource

  ]
}