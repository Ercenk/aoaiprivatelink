metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

@description('Subnet ID for the NIC')
param subnetId string

var virtualMachineName = '${customerName}-vm'

var location = resourceGroup().location

var vmSize = 'Standard_D2s_v3'
var osDiskName = '${virtualMachineName}_${uniqueString(resourceGroup().id)}'

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
          id: resourceId('Microsoft.Compute/disks', '${osDiskName}')
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
  }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        provisionVMAgent: true
        patchSetting: {
          patchMode: 'AutomaticByOS'
        }
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${virtualMachineName}-nic')
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
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', '${virtualMachineName}-nsg')
    }
    nicType: 'Standard'
  }
}
