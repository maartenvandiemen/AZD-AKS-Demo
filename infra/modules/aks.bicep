@description('The tags to associate with the resource')
param tags object

@description('Name of the ACR to use in the same resource group')
param acrName string

var uniqueName = uniqueString(resourceGroup().id, subscription().id)
var aksName = 'aks-${uniqueName}'

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: acrName
}

resource aks 'Microsoft.ContainerService/managedClusters@2026-06-01' = {
  name: aksName
  tags: tags
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azureMonitorProfile: {
      metrics: {
        enabled: true
      }
    }
    dnsPrefix: '${aksName}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0
        count: 2
        vmSize: 'Standard_D2_v3'
        osType: 'Linux'
        mode: 'System'
      }
    ]    
    addonProfiles: {
      // Metrics go to the Azure Monitor workspace (Managed Prometheus) and are shown in Grafana, so Container Insights / Log Analytics isn't used.
      // Explicitly disabled so it also gets turned off on a cluster that was deployed with it.
      omsagent: {
        enabled: false
      }
    }
  }
}

resource roleAssignmentACR 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(aks.name, resourceGroup().id, 'AcrPull')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: aks.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
  }
}

output clusterName string = aks.name
