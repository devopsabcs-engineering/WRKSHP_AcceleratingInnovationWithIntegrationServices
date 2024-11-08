@description('The name of the API Management service instance')
param apimServiceName string

@description('The Service Bus Namespace')
param sbNameSpace string

resource apimInstance 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apimServiceName
}

var apimId = apimInstance.identity.principalId

resource sbInstance 'Microsoft.ServiceBus/namespaces@2023-01-01-preview' existing = {
  name: sbNameSpace
}

@description('This is the built-in Azure Service Bus Data Sender role. ')
resource sbDataSenderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  scope: sbInstance
  name: '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: sbInstance
  name: guid(resourceGroup().id, apimInstance.id, sbDataSenderRoleDefinition.id)
  properties: {
    roleDefinitionId: sbDataSenderRoleDefinition.id
    principalId: apimId
    principalType: 'ServicePrincipal'
  }
}
