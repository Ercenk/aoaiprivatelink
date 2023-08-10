@description('Specifies the location for all the resources.')
param location string = resourceGroup().location

@description('Specifies the name of the virtual network hosting the virtual machine.')
param virtualNetworkName string = 'UbuntuVnet'

@description('Specifies the address prefix of the virtual network hosting the virtual machine.')
param virtualNetworkAddressPrefix string = '10.0.0.0/16'

@description('Specifies the name of the subnet hosting the virtual machine.')
param subnetName string = 'DefaultSubnet'

@description('Specifies the address prefix of the subnet hosting the virtual machine.')
param subnetAddressPrefix string = '10.0.0.0/24'

@description('Specifies the globally unique name for the storage account used to store the boot diagnostics logs of the virtual machine.')
param blobStorageAccountName string = 'boot${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the virtual machine.')
param vmName string = 'TestVm'

@description('Specifies the size of the virtual machine.')
param vmSize string = 'Standard_D4s_v3'

@description('Specifies the image publisher of the disk image used to create the virtual machine.')
param imagePublisher string = 'Canonical'

@description('Specifies the offer of the platform image or marketplace image used to create the virtual machine.')
param imageOffer string = 'UbuntuServer'

@description('Specifies the Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
param imageSku string = '18.04-LTS'

@description('Specifies the type of authentication when accessing the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

@description('Specifies the name of the administrator account of the virtual machine.')
param adminUsername string

@description('Specifies the SSH Key or password for the virtual machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

@description('Defines the storage account type for OS and data disk.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param diskStorageAccounType string = 'Premium_LRS'

@description('Specifies the number of data disks of the virtual machine.')
@minValue(0)
@maxValue(64)
param numDataDisks int = 1

@description('The size in GB of the OS disk of the VM.')
param osDiskSize int = 100

@description('Specifies the size in GB of the OS disk of the virtual machine.')
param dataDiskSize int = 10

@description('Specifies the caching requirements for the data disks.')
param dataDiskCaching string = 'ReadWrite'

@description('Specifies the base URI where artifacts required by this template are located including a trailing \'/\'')
param _artifactsLocation string = deployment().properties.templateLink.uri

@description('Specifies the sasToken required to access _artifactsLocation.  When the template is deployed using the accompanying scripts, a sasToken will be automatically generated. Use the defaultValue if the staging location is not secured.')
@secure()
param _artifactsLocationSasToken string = ''

@description('Specifies the script to download from the URI specified by the scriptFilePath parameter.')
param scriptFileName string = 'test-key-vault-private-endpoint.sh'

@description('Specifies whether to deploy a Log Analytics workspace to monitor the health and performance of the virtual machine.')
param deployLogAnalytics bool = true

@description('Specifies the globally unique name of the Log Analytics workspace.')
param workspaceName string

@description('Specifies the SKU of the Log Analytics workspace.')
@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
param workspaceSku string = 'PerGB2018'

@description('Specifies the name of the key vault.')
param keyVaultName string = 'vault${uniqueString(resourceGroup().id)}'

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
@allowed([
  true
  false
])
param enabledForDeployment bool = true

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
@allowed([
  true
  false
])
param enabledForDiskEncryption bool = true

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
@allowed([
  true
  false
])
param enabledForTemplateDeployment bool = true

@description('Specifies whether the \'soft delete\' functionality is enabled for this key vault. If it\'s not set to any value(true or false) when creating new key vault, it will be set to true by default. Once set to true, it cannot be reverted to false.')
@allowed([
  true
  false
])
param enableSoftDelete bool = true

@description('Specifies the softDelete data retention days. It accepts >=7 and <=90.')
param softDeleteRetentionInDays int = 90

@description('Controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.')
@allowed([
  true
  false
])
param enableRbacAuthorization bool = false

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
param keysPermissions array = [
  'get'
  'create'
  'delete'
  'list'
  'update'
  'import'
  'backup'
  'restore'
  'recover'
]

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array = [
  'get'
  'list'
  'set'
  'delete'
  'backup'
  'restore'
  'recover'
]

@description('Specifies the permissions to certificates in the vault. Valid values are: all, get, list, set, delete, managecontacts, getissuers, listissuers, setissuers, deleteissuers, manageissuers, backup, and recover.')
param certificatesPermissions array = [
  'get'
  'list'
  'delete'
  'create'
  'import'
  'update'
  'managecontacts'
  'getissuers'
  'listissuers'
  'setissuers'
  'deleteissuers'
  'manageissuers'
  'backup'
  'recover'
]

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Specifies all secrets {"secretName":"","secretValue":""} wrapped in a secure object.')
param secretsArray array = [
  {
    secretName: 'secret1'
    secretValue: 'value1'
  }
  {
    secretName: 'secret2'
    secretValue: 'value2'
  }
  {
    secretName: 'secret3'
    secretValue: 'value3'
  }
]

@description('Specifies the name of the private link to key vault.')
param keyVaultPrivateEndpointName string = 'KeyVaultPrivateEndpoint'

@description('Specifies the name of the private link to the boot diagnostics storage account.')
param blobStorageAccountPrivateEndpointName string = 'BlobStorageAccountPrivateEndpoint'

var nicName = '${vmName}Nic'
var nsgName = '${subnetName}Nsg'
var publicIPAddressName = '${vmName}PublicIp'
var publicIPAddressType = 'Dynamic'
var workspaceId = workspace.id
var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
var publicIpId = publicIPAddress.id
var nicId = nic.id
var vnetId = virtualNetwork.id
var nsgId = nsg.id
var vmId = vm.id
var customScriptId = vmName_CustomScript.id
var omsAgentForLinuxId = vmName_LogAnalytics.id
var scriptFileUri = uri(_artifactsLocation, 'scripts/${scriptFileName}${_artifactsLocationSasToken}')
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
  provisionVMAgent: true
}
var keyVaultId = keyVault.id
var blobStorageAccountId = blobStorageAccount.id
var keyVaultPublicDNSZoneForwarder = ((toLower(environment().name) == 'azureusgovernment') ? '.vaultcore.usgovcloudapi.net' : '.vaultcore.azure.net')
var blobPublicDNSZoneForwarder = '.blob.${environment().suffixes.storage}'
var keyVaultPrivateDnsZoneName = 'privatelink${keyVaultPublicDNSZoneForwarder}'
var blobPrivateDnsZoneName = 'privatelink${blobPublicDNSZoneForwarder}'
var keyVaultPrivateDnsZoneId = keyVaultPrivateDnsZone.id
var blobPrivateDnsZoneId = blobPrivateDnsZone.id
var keyVaultServiceEndpoint = concat(keyVaultName, environment().suffixes.keyvaultDns)
var blobServicePrimaryEndpoint = concat(blobStorageAccountName, blobPublicDNSZoneForwarder)
var keyVaultPrivateEndpointId = keyVaultPrivateEndpoint.id
var blobStorageAccountPrivateEndpointId = blobStorageAccountPrivateEndpoint.id
var keyVaultPrivateEndpointGroupName = 'vault'
var blobStorageAccountPrivateEndpointGroupName = 'blob'
var azureEnvironment = environment().name
var keyVaultPrivateDnsZoneGroupName = '${keyVaultPrivateEndpointName}/${keyVaultPrivateEndpointGroupName}PrivateDnsZoneGroup'
var blobPrivateDnsZoneGroupName = '${blobStorageAccountPrivateEndpointName}/${blobStorageAccountPrivateEndpointGroupName}PrivateDnsZoneGroup'
var keyVaultPrivateDnsZoneGroupId = resourceId('Microsoft.Network/privateEndpoints/privateDnsZoneGroups', keyVaultPrivateEndpointName, '${keyVaultPrivateEndpointGroupName}PrivateDnsZoneGroup')

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      name: skuName
      family: 'A'
    }
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: reference(vmId, '2019-12-01', 'Full').identity.principalId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatesPermissions
        }
      }
    ]
  }
  dependsOn: [
    vmId
  ]
}

resource keyVaultName_secretsArray_secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = [for item in secretsArray: {
  name: '${keyVaultName}/${item.secretName}'
  properties: {
    value: item.secretValue
  }
  dependsOn: [
    keyVaultId
  ]
}]

resource blobStorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: blobStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2020-04-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: concat(toLower(vmName), uniqueString(resourceGroup().id))
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2019-08-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSshInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: nsgId
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
  dependsOn: [
    nsgId
  ]
}

resource nic 'Microsoft.Network/networkInterfaces@2020-04-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
  dependsOn: [
    publicIpId
    vnetId
  ]
}

resource vm 'Microsoft.Compute/virtualMachines@2019-12-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? json('null') : linuxConfiguration)
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: osDiskSize
        managedDisk: {
          storageAccountType: diskStorageAccounType
        }
      }
      dataDisks: [for j in range(0, numDataDisks): {
        caching: dataDiskCaching
        diskSizeGB: dataDiskSize
        lun: j
        name: '${vmName}-DataDisk${j}'
        createOption: 'Empty'
        managedDisk: {
          storageAccountType: diskStorageAccounType
        }
      }]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(blobStorageAccountId).primaryEndpoints.blob
      }
    }
  }
  dependsOn: [
    blobStorageAccountPrivateEndpointId
    nicId
  ]
}

resource vmName_CustomScript 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = {
  parent: vm
  name: 'CustomScript'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: {
      skipDos2Unix: false
      timestamp: 123456789
      fileUris: [
        scriptFileUri
      ]
    }
    protectedSettings: {
      commandToExecute: 'bash ${scriptFileName} ${keyVaultServiceEndpoint} ${blobServicePrimaryEndpoint} ${azureEnvironment}'
    }
  }
  dependsOn: [
    vmId
    keyVaultId
    keyVaultPrivateEndpointId
    keyVaultPrivateDnsZoneGroupId
  ]
}

resource vmName_LogAnalytics 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = if (deployLogAnalytics) {
  parent: vm
  name: 'LogAnalytics'
  location: location
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'OmsAgentForLinux'
    typeHandlerVersion: '1.12'
    settings: {
      workspaceId: reference(workspaceId, '2020-03-01-preview').customerId
      stopOnMultipleConnections: false
    }
    protectedSettings: {
      workspaceKey: listKeys(workspaceId, '2020-03-01-preview').primarySharedKey
    }
  }
  dependsOn: [
    vmId
    workspaceId
    customScriptId
  ]
}

resource vmName_DependencyAgent 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = if (deployLogAnalytics) {
  parent: vm
  name: 'DependencyAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentLinux'
    typeHandlerVersion: '9.10'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vmId
    workspaceId
    customScriptId
    omsAgentForLinuxId
  ]
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = if (deployLogAnalytics) {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: workspaceSku
    }
  }
}

resource workspaceName_Kern 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'Kern'
  kind: 'LinuxSyslog'
  properties: {
    syslogName: 'kern'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_Syslog 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'Syslog'
  kind: 'LinuxSyslog'
  properties: {
    syslogName: 'syslog'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_User 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'User'
  kind: 'LinuxSyslog'
  properties: {
    syslogName: 'user'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_SampleSyslogCollection1 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'SampleSyslogCollection1'
  kind: 'LinuxSyslogCollection'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_DiskPerfCounters 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'DiskPerfCounters'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: '% Used Inodes'
      }
      {
        counterName: 'Free Megabytes'
      }
      {
        counterName: '% Used Space'
      }
      {
        counterName: 'Disk Transfers/sec'
      }
      {
        counterName: 'Disk Reads/sec'
      }
      {
        counterName: 'Disk Writes/sec'
      }
      {
        counterName: 'Disk Read Bytes/sec'
      }
      {
        counterName: 'Disk Write Bytes/sec'
      }
    ]
    objectName: 'Logical Disk'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_ProcessorPerfCounters 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'ProcessorPerfCounters'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: '% Processor Time'
      }
      {
        counterName: '% User Time'
      }
      {
        counterName: '% Privileged Time'
      }
      {
        counterName: '% IO Wait Time'
      }
      {
        counterName: '% Idle Time'
      }
      {
        counterName: '% Interrupt Time'
      }
    ]
    objectName: 'Processor'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_ProcessPerfCounters 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'ProcessPerfCounters'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: '% User Time'
      }
      {
        counterName: '% Privileged Time'
      }
      {
        counterName: 'Used Memory'
      }
      {
        counterName: 'Virtual Shared Memory'
      }
    ]
    objectName: 'Process'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_SystemPerfCounters 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'SystemPerfCounters'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: 'Processes'
      }
    ]
    objectName: 'System'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_NetworkPerfCounters 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'NetworkPerfCounters'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: 'Total Bytes Transmitted'
      }
      {
        counterName: 'Total Bytes Received'
      }
      {
        counterName: 'Total Bytes'
      }
      {
        counterName: 'Total Packets Transmitted'
      }
      {
        counterName: 'Total Packets Received'
      }
      {
        counterName: 'Total Rx Errors'
      }
      {
        counterName: 'Total Tx Errors'
      }
      {
        counterName: 'Total Collisions'
      }
    ]
    objectName: 'Network'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_MemorydataSources 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'MemorydataSources'
  kind: 'LinuxPerformanceObject'
  properties: {
    performanceCounters: [
      {
        counterName: 'Available MBytes Memory'
      }
      {
        counterName: '% Available Memory'
      }
      {
        counterName: 'Used Memory MBytes'
      }
      {
        counterName: '% Used Memory'
      }
    ]
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 10
  }
  dependsOn: [
    workspaceId
  ]
}

resource workspaceName_SampleLinuxPerfCollection1 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (deployLogAnalytics) {
  parent: workspace
  name: 'SampleLinuxPerfCollection1'
  kind: 'LinuxPerformanceCollection'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    workspaceId
  ]
}

resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: keyVaultPrivateDnsZoneName
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
  }
}

resource blobPrivateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: blobPrivateDnsZoneName
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
  }
}

resource keyVaultPrivateDnsZoneName_link_to_virtualNetwork 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: keyVaultPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
  dependsOn: [
    keyVaultPrivateDnsZoneId
    vnetId
  ]
}

resource blobPrivateDnsZoneName_link_to_virtualNetwork 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: blobPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
  dependsOn: [
    blobPrivateDnsZoneId
    vnetId
  ]
}

resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-04-01' = {
  name: keyVaultPrivateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyVaultPrivateEndpointName
        properties: {
          privateLinkServiceId: keyVaultId
          groupIds: [
            keyVaultPrivateEndpointGroupName
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
    customDnsConfigs: [
      {
        fqdn: concat(keyVaultName, keyVaultPublicDNSZoneForwarder)
      }
    ]
  }
  dependsOn: [
    vnetId
    keyVaultId
  ]
}

resource blobStorageAccountPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-04-01' = {
  name: blobStorageAccountPrivateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: blobStorageAccountPrivateEndpointName
        properties: {
          privateLinkServiceId: blobStorageAccountId
          groupIds: [
            blobStorageAccountPrivateEndpointGroupName
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
    customDnsConfigs: [
      {
        fqdn: concat(blobStorageAccountName, blobPublicDNSZoneForwarder)
      }
    ]
  }
  dependsOn: [
    vnetId
    blobStorageAccountId
  ]
}

resource keyVaultPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
  name: keyVaultPrivateDnsZoneGroupName
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZoneId
        }
      }
    ]
  }
  dependsOn: [
    keyVaultId
    keyVaultPrivateDnsZoneId
    keyVaultPrivateEndpointId
  ]
}

resource blobPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
  name: blobPrivateDnsZoneGroupName
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: blobPrivateDnsZoneId
        }
      }
    ]
  }
  dependsOn: [
    blobPrivateDnsZoneId
    blobStorageAccountPrivateEndpointId
  ]
}

output keyVaultPrivateEndpoint object = reference(keyVaultPrivateEndpoint.id, '2020-04-01', 'Full')
output blobStorageAccountPrivateEndpoint object = reference(blobStorageAccountPrivateEndpoint.id, '2020-04-01', 'Full')
output keyVault object = reference(keyVault.id, '2019-09-01', 'Full')
output blobStorageAccount object = reference(blobStorageAccount.id, '2019-06-01', 'Full')
output adminUsername string = adminUsername
output workspaceName string = workspaceName
output scriptFileUri string = scriptFileUri
output environment object = environment()