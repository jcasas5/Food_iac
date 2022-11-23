@sys.description('The Web App name.')
@minLength(3)
@maxLength(24)
param appServiceAppName string = 'default-app-bicep'
@sys.description('Tha Web App name.')
@minLength(3)
@maxLength(24)
param appServicePlanName string = 'default-asp-bicep'
@sys.description('Tha Web App name.')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'defaultstoragebicep'
param location string = resourceGroup().location
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: { 
    location: location
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
