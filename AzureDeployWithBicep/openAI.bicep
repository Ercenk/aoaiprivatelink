metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Customer name')
param customerName string

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

output openAIId string = azureOpenAI.id
output openAIName string = azureOpenAI.name
