metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Tenant name')
param tenantName string

@description('Subnet ID for the NIC')
param subnetId string

@description('SSH public key for the VM')
param sshPublicKey string

@description('Uri for Key Vault')
param keyVaultUri string

@description('Name of the Key Vault')
param keyVaultName string

var virtualMachineName = '${tenantName}-vm'

var location = resourceGroup().location

var vmSize = 'Standard_D2s_v3'
var osDiskName = '${virtualMachineName}_${uniqueString(resourceGroup().id)}'
var username = 'azureuser'

var keyVaultEnvironmentVar = base64('#cloud-config\nwrite_files:\n- path: /etc/profile.d/my_var.sh\n  content: |-\n    export KEYVAULTURI=${keyVaultUri}\n    permissions: \'0644\'')
resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachineName
  location: location
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
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
        name: osDiskName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
  }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: username
      customData: keyVaultEnvironmentVar
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${username}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
        provisionVMAgent: true
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${virtualMachineName}-nic'
  location: location
  kind: 'regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAddressVersion: 'IPv4'
          primary: true
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    nicType: 'Standard'
  }
}

resource tenantKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}
var roleAssignmentName = guid('${tenantName}-vm-role-assignment')

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: tenantKeyVault
  dependsOn: [
    virtualMachine
  ]
  properties: {
    principalId: virtualMachine.identity.principalId
    // This is the resource id for the built in role for "Key Vault Secrets User"
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}//providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'
  }
}

output virtualMachineName string = virtualMachine.name
