@description('The name of the Function App instance')
param functionAppName string

@secure()
param currentAppSettings object

@secure()
param customAppSettings object

resource functionAppInstance 'Microsoft.Web/sites@2023-12-01' existing = {
  name: functionAppName
}

resource appsettings 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: functionAppInstance
  name: 'appsettings'
  properties: union(customAppSettings, currentAppSettings)
}
