
resource sshPublicKeys_cust_a_vm_key_name_resource 'Microsoft.Compute/sshPublicKeys@2023-03-01' = {
  name: sshPublicKeys_cust_a_vm_key_name
  location: 'eastus'
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtc+OKyVnU8SsSV07ccb8AOaQ27DoZKFA6jkUh/1hI6h6YI7ygtYQkFO9Srs5y5bw0jUByMPyMAhlUljlzd5sZA0hNHG78WJPkb+oD92ghBM07jt5HMqsIgRHmueIAntioqerN5t0TxFixZalSz3ZMlFKaWHjuflrDfna2ZWDXigIY5JqJGdERFR4PNfjqeGrC1PyeByQ5CXP7+uw54PpH13kZ+zmWT++K0nCs1Ma1ZfeFA9I2Re+lyjAW4n6IKY5NMG1sLrEWoxqvJX7F1WWvC8RHWZS0l1qNQiQPgTgZ5yWwG/0dnGAjnzu6/zPuwuYn5LG4k7V98fv9hBh2WGlVqjzgsVqnQrExmQbvP9UwvurxQC3D+OJeK+TUDtnlZjtH/tH6aBRGXZY2kx4myCtfotNTVtscDiZGB+pyhhgHzQoBE75JaGjAKKzI3LGL9hID9FpIQsEPFG+1hS0ALWxMtEeVxWlUSIjCLRSStSDzgA9jqKSd+9YfDtAwo8Q5P2E= generated-by-azure'
  }
}

resource networkSecurityGroups_cust_a_vnet_privateendpoints_nsg_eastus_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSecurityGroups_cust_a_vnet_privateendpoints_nsg_eastus_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'AllowCorpnet'
        id: networkSecurityGroups_cust_a_vnet_privateendpoints_nsg_eastus_name_AllowCorpnet.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2700
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowSAW'
        id: networkSecurityGroups_cust_a_vnet_privateendpoints_nsg_eastus_name_AllowSAW.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2701
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_cust_a_vm_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSecurityGroups_cust_a_vm_nsg_name
  location: 'eastus'
  properties: {
    securityRules: []
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_openai_azure_com_name
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
    numberOfRecordSets: 5
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

resource publicIPAddresses_cust_a_vnet_ip_name_resource 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddresses_cust_a_vnet_ip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.232.112.253'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}


resource accounts_erc_cust_a_aoai_name_cust_a_priv_endpoint_696c685d_9173_4450_aefa_bb28466e1c60 'Microsoft.CognitiveServices/accounts/privateEndpointConnections@2023-05-01' = {
  parent: accounts_erc_cust_a_aoai_name_resource
  name: 'cust-a-priv-endpoint.696c685d-9173-4450-aefa-bb28466e1c60'
  location: 'eastus'
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

resource virtualMachines_cust_a_vm_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_cust_a_vm_name
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_cust_a_vm_name}_OsDisk_1_e4e46d5f4ec24f0cb3771313a425843a'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_cust_a_vm_name}_OsDisk_1_e4e46d5f4ec24f0cb3771313a425843a')
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_cust_a_vm_name
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtc+OKyVnU8SsSV07ccb8AOaQ27DoZKFA6jkUh/1hI6h6YI7ygtYQkFO9Srs5y5bw0jUByMPyMAhlUljlzd5sZA0hNHG78WJPkb+oD92ghBM07jt5HMqsIgRHmueIAntioqerN5t0TxFixZalSz3ZMlFKaWHjuflrDfna2ZWDXigIY5JqJGdERFR4PNfjqeGrC1PyeByQ5CXP7+uw54PpH13kZ+zmWT++K0nCs1Ma1ZfeFA9I2Re+lyjAW4n6IKY5NMG1sLrEWoxqvJX7F1WWvC8RHWZS0l1qNQiQPgTgZ5yWwG/0dnGAjnzu6/zPuwuYn5LG4k7V98fv9hBh2WGlVqjzgsVqnQrExmQbvP9UwvurxQC3D+OJeK+TUDtnlZjtH/tH6aBRGXZY2kx4myCtfotNTVtscDiZGB+pyhhgHzQoBE75JaGjAKKzI3LGL9hID9FpIQsEPFG+1hS0ALWxMtEeVxWlUSIjCLRSStSDzgA9jqKSd+9YfDtAwo8Q5P2E= generated-by-azure'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_cust_a_vm368_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    priority: 'Spot'
    evictionPolicy: 'Deallocate'
    billingProfile: {
      maxPrice: -1
    }
  }
}

resource schedules_shutdown_computevm_cust_a_vm_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_cust_a_vm_name
  location: 'eastus'
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'Pacific Standard Time'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'Ercenk.Keresteci@microsoft.com'
      notificationLocale: 'en'
    }
    targetResourceId: virtualMachines_cust_a_vm_name_resource.id
  }
}

resource vaults_cust_a_kv_name_kvprivep_8adf0824_956d_4c2f_b613_3ccfeb5de03b 'Microsoft.KeyVault/vaults/privateEndpointConnections@2023-02-01' = {
  parent: vaults_cust_a_kv_name_resource
  name: 'kvprivep_8adf0824-956d-4c2f-b613-3ccfeb5de03b'
  location: 'eastus'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      actionsRequired: 'None'
    }
  }
}

resource vaults_cust_a_kv_name_aoaiapikey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: vaults_cust_a_kv_name_resource
  name: 'aoaiapikey'
  location: 'eastus'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_cust_a_kv_name_aoaiendpoint 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: vaults_cust_a_kv_name_resource
  name: 'aoaiendpoint'
  location: 'eastus'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource networkInterfaces_cust_a_priv_endpoint_nic_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_cust_a_priv_endpoint_nic_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.6bf266c1-3ea3-4585-b1ad-84253fa8b5f8'
        id: '${networkInterfaces_cust_a_priv_endpoint_nic_name_resource.id}/ipConfigurations/privateEndpointIpConfig.6bf266c1-3ea3-4585-b1ad-84253fa8b5f8'
        etag: 'W/"e134146e-1e91-4ed4-8093-24321c1c3242"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.1.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_cust_a_vnet_name_privateendpoints.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateLinkConnectionProperties: {
            groupId: 'account'
            requiredMemberName: 'default'
            fqdns: [
              'erc-cust-a-aoai.openai.azure.com'
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

resource networkInterfaces_kvprivep_nic_d4507eb9_2620_4777_8aea_6943875f0c41_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_kvprivep_nic_d4507eb9_2620_4777_8aea_6943875f0c41_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.e9b28b94-3e46-4952-932c-759408acab57'
        id: '${networkInterfaces_kvprivep_nic_d4507eb9_2620_4777_8aea_6943875f0c41_name_resource.id}/ipConfigurations/privateEndpointIpConfig.e9b28b94-3e46-4952-932c-759408acab57'
        etag: 'W/"aaa7f69f-3771-4bd2-8278-61337c4e9ee1"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_cust_a_vnet_name_privateendpoints.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateLinkConnectionProperties: {
            groupId: 'vault'
            requiredMemberName: 'default'
            fqdns: [
              'cust-a-kv.vault.azure.net'
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

resource privateDnsZones_privatelink_vaultcore_azure_net_name_cust_a_kv 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_vaultcore_azure_net_name_resource
  name: 'cust-a-kv'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.0.1.4'
      }
    ]
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_cust_a_vm 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'cust-a-vm'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.0.4'
      }
    ]
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_erc_cust_a_aoai 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'erc-cust-a-aoai'
  properties: {
    metadata: {
      creator: 'created by private endpoint cust-a-priv-endpoint with resource guid 696c685d-9173-4450-aefa-bb28466e1c60'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.1.5'
      }
    ]
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_vm000000 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'vm000000'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.2.4'
      }
    ]
  }
}

resource privateDnsZones_privatelink_openai_azure_com_name_vm000001 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'vm000001'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.2.5'
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


resource privateDnsZones_privatelink_openai_azure_com_name_on7u2r53hps3w 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_openai_azure_com_name_resource
  name: 'on7u2r53hps3w'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_cust_a_vnet_name_resource.id
    }
  }
}

resource privateDnsZones_privatelink_vaultcore_azure_net_name_on7u2r53hps3w 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_vaultcore_azure_net_name_resource
  name: 'on7u2r53hps3w'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_cust_a_vnet_name_resource.id
    }
  }
}

resource privateEndpoints_cust_a_priv_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: privateEndpoints_cust_a_priv_endpoint_name
  location: 'eastus'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_cust_a_priv_endpoint_name
        id: '${privateEndpoints_cust_a_priv_endpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_cust_a_priv_endpoint_name}'
        properties: {
          privateLinkServiceId: accounts_erc_cust_a_aoai_name_resource.id
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
    customNetworkInterfaceName: '${privateEndpoints_cust_a_priv_endpoint_name}-nic'
    subnet: {
      id: virtualNetworks_cust_a_vnet_name_privateendpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_kvprivep_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: privateEndpoints_kvprivep_name
  location: 'eastus'
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoints_kvprivep_name}_8adf0824-956d-4c2f-b613-3ccfeb5de03b'
        id: '${privateEndpoints_kvprivep_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_kvprivep_name}_8adf0824-956d-4c2f-b613-3ccfeb5de03b'
        properties: {
          privateLinkServiceId: vaults_cust_a_kv_name_resource.id
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
      id: virtualNetworks_cust_a_vnet_name_privateendpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: 'cust-a-kv.vault.azure.net'
        ipAddresses: [
          '10.0.1.4'
        ]
      }
    ]
  }
}

resource privateEndpoints_cust_a_priv_endpoint_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = {
  name: '${privateEndpoints_cust_a_priv_endpoint_name}/default'
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
    privateEndpoints_cust_a_priv_endpoint_name_resource

  ]
}
