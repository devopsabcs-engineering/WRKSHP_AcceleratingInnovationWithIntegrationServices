@description('The name of the Function App instance')
param functionAppName string

@description('The name of the CosmosDB instance')
param cosmosAccountName string

@description('The Service Bus Namespace Host Name')
param sbHostName string

//param repositoryUrl string = 'https://github.com/devopsabcs-engineering/WRKSHP_AcceleratingInnovationWithIntegrationServices.git'
//param branch string = 'main'

resource functionAppInstance 'Microsoft.Web/sites@2021-03-01' existing = {
  name: functionAppName
}

resource cosmosDBInstance 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: cosmosAccountName
}

var customAppSettings = {
  CosmosDbConnectionString: cosmosDBInstance.listConnectionStrings().connectionStrings[0].connectionString
  SBConnectionString__fullyQualifiedNamespace: sbHostName
}

var currentAppSettings = list('${functionAppInstance.id}/config/appsettings', '2023-12-01').properties

module configurFunctionAppSettings './append-function-appsettings.bicep' = {
  name: '${functionAppName}-appendsettings'
  params: {
    functionAppName: functionAppName
    currentAppSettings: currentAppSettings
    customAppSettings: customAppSettings
  }
}

// resource srcControls 'Microsoft.Web/sites/sourcecontrols@2023-12-01' = {
//   name: 'web'
//   parent: functionAppInstance
//   properties: {
//     repoUrl: repositoryUrl
//     branch: branch
//     isManualIntegration: true
//   }
//   dependsOn: [
//     configurFunctionAppSettings
//   ]
// }
