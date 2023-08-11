metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('API management Virtual Network')
param apiManagementVnetName string = 'apim-vnet'

@description('Location of the resources')
param location string = resourceGroup().location

// Create the API management Vnet

resource apiManagementVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: apiManagementVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        // Notice the address space
        '10.1.0.0/16'
      ]
    }
    subnets:[
      {
        name: 'default'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

resource apiManagement 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: 'myApiManagement'
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: 'admin@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkConfiguration: {
      // Notice the default subnet is hardcoded with the subnet in the Vnet
      subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', apiManagementVnetName, 'default')
      vnetResourceId: apiManagementVnet.id
    }
    virtualNetworkType: 'External'
  }
}


output apiManagementVnetName string = apiManagementVnet.name
