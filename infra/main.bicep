targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

var tags = {
  'azd-env-name': environmentName
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module acr 'modules/containerRegistry.bicep' ={
  name: 'acr'
  scope: rg
  params: {
    tags: tags
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  scope: rg
  params: {
    acrName: acr.outputs.registryName
    tags: tags
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  scope: rg
  params: {
    tags: tags
    aksName: aks.outputs.clusterName
  }
}

output AZURE_REGISTRY_NAME string = acr.outputs.registryName
output AZURE_REGISTRY_URI string = acr.outputs.loginServer
output AZURE_RG_NAME string = rg.name
output AZURE_AKS_CLUSTERNAME string = aks.outputs.clusterName
output AZURE_MONITOR_NAME string = monitoring.outputs.monitorWorkspaceName
