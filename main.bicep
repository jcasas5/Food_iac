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

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

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

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
