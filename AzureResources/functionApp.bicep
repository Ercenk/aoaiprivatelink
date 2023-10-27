metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Tenant name')
param tenantName string

@description('Name of the Key Vault')
param keyVaultName string

@description('Uri for Key Vault')
param keyVaultUri string

var functionAppName = '${tenantName}${substring(uniqueString(resourceGroup().id), 0, 5)}'

var storageAccountName = '${functionAppName}-sa'

var storageAccountType = 'Standard_LRS'

var location = resourceGroup().location

// Create storeage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountType
  }
  properties: {
    accessTier: 'Hot'
  }
}

// Hosting plan
var hostingPlanName = functionAppName
resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

// Create app insights resource
var appInsightsName = functionAppName

resource  appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    ApplicationId: functionAppName
  }
}

// Create the function app
var runtime = 'dotnet'

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccount.listKeys().keys[0].value
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(resourceId('microsoft.insights/components', appInsightsName), '2020-02-02').InstrumentationKey
        }
        {
          name: 'KEYVAULTURI'
          value: keyVaultUri
        }
      ]
    }
  }
}

resource tenantKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}
var roleAssignmentName = guid('${tenantName}-funcapp-role-assignment')

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: tenantKeyVault
  properties: {
    principalId: functionApp.identity.principalId
    // This is the resource id for the built in role for "Key Vault Secrets User"
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}//providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'
  }
}

output functionAppName string = functionApp.name
