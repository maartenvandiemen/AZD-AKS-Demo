@description('The tags to associate with the resource')
param tags object

var uniqueName = uniqueString(resourceGroup().id, subscription().id)
var registryName = 'acr${uniqueName}'

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' = {
  name: registryName
  location: resourceGroup().location
  properties: {
    // AKS pulls with its kubelet identity (AcrPull, see aks.bicep), so the admin user isn't needed
    adminUserEnabled: false
  }
  tags: tags
  sku: {
    name: 'Basic'
  }
}

var identityName = 'identity-${uniqueName}'

resource userId 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  location: resourceGroup().location
  name: identityName
  tags: tags
}

resource roleAssignmentACR 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registryName, resourceGroup().id, userId.id, 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: userId.properties.principalId
    principalType: 'ServicePrincipal'
    description: 'Contributor access for the acr for user assigned identity which is necessary for importing the image.'
  }
}

resource roleAssignmentRG 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(resourceGroup().name, resourceGroup().id, userId.id, 'Reader')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
    principalId: userId.properties.principalId
    principalType: 'ServicePrincipal'
    description: 'Read access for the resource group for user assigned identity which is necessary for finding the acr when executing the deployment script.'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'ImportImageScript'
  location: resourceGroup().location
  dependsOn: [roleAssignmentACR]
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {      
      '${userId.id}' : {}
    }
  }
  properties: {
    azCliVersion: '2.89.1'
    scriptContent: 'az acr import --name ${registryName} --source ghcr.io/maartenvandiemen/eshoponwebmvc:latest --image maartenvandiemen/eshoponwebmvc:latest --force'
    retentionInterval: 'PT1H'
  }
}

output registryName string = registry.name
output loginServer string = registry.properties.loginServer
