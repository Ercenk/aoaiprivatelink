using './main.bicep'

param tenantName = 'custd'
param location = 'eastus'
param sshPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZIjbNlt/iGFq3gVKKsP22tVDKZgCF2XiAM26dV6fuYgG5bC81p3an9tO5DtoCxwNnsVas69HdKiJ5hzTU4Yxvryrp52dMBYyS942RWXegFbci7yhXct775K7b/yT6ypKclGXf70lTPxaeAUiSLivCxo/Ofr0H8xybhyhkHYz42yEr67mHcFCAmfjSenvofEVgPMq1lSu1sKouNUrJadQ59pgqiG/9NWItqq7BptI/b1NTFt1HaFcxdscujO35nD+xeBrnEnOIEyyC6P6g7W8VqX1S6EMh8/v7+SWgwFahZIsyqYiJmySHpwErZxmZWkteiy1p6UQ/37C4BkiKOx+hfK7wdD+AVUHDnFEE2KTaJZUvgfbQhYhKtTRFYNBiysKh8PhCAGXfoWlmwdaJeXpPWP7CIFzJqNrEaV4ojjkL7kywsPGbIY0D/rQJzrirBsRHuS1IIuciv079WAzMYSo8P9O+4l6/WPqxZZ0hxDZwrg8mMY6ZZLEGvSsNnYou5dc= generated-locally'
param apimRgName = 'apim-rg'
param apimVnetName = 'apim-vnet'
param virtualNetworkAddressSpacePrefix = '10.0.0.0/16'
param appSubnetPrefix = '10.0.0.0/24'
param privateEndpointsSubnetPrefix = '10.0.1.0/24'
param useVm = false
