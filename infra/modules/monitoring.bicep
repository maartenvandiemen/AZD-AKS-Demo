@description('The tags to associate with the resource')
param tags object

param aksName string

var uniqueName = uniqueString(resourceGroup().id, subscription().id)

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' existing = {
  name: aksName
}

resource monitorWorkspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: 'monitor-${uniqueName}'
  location: resourceGroup().location
  tags: tags
}

resource grafana 'Microsoft.Dashboard/grafana@2023-09-01' = {
  name: 'grafana-${uniqueName}'
  location: resourceGroup().location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Essential'
  }
  properties: {
    grafanaIntegrations: {
      azureMonitorWorkspaceIntegrations: [
        {
          azureMonitorWorkspaceResourceId: monitorWorkspace.id
        }
      ]
    }
  }
}

resource monitoringDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b0d8363b-8ddd-447d-831f-62ca05bff136'
  scope: subscription()
}

resource dataCollectionRuleAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2023-03-11' = {
  name: 'dataCollectionRA-${uniqueName}'
  scope: aks
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster.'
    dataCollectionRuleId: monitorWorkspace.properties.defaultIngestionSettings.dataCollectionRuleResourceId
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().name, resourceGroup().id, monitorWorkspace.id, 'MonitoringDataReader')
  scope: monitorWorkspace
  properties: {
    principalId: grafana.identity.principalId
    roleDefinitionId: monitoringDataReaderRole.id
    principalType: 'ServicePrincipal'
  }
}


output monitorWorkspaceName string = monitorWorkspace.name
