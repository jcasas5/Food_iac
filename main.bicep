@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName1 string = 'jcasasus-assignment-be-pro'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName3 string = 'jcasasus-assignment-fe-pro'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName1 string = 'jcasasus-assignment-pro'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName2 string = 'jcasasus-assignment-be-dev'
@minLength(3)
@maxLength(30)
param appServiceAppName4 string = 'jcasasus-assignment-fe-dev'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName2 string = 'jcasasus-assignment-dev'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(30)
param storageAccountName string = 'jcasasusstorage'
@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location
@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

param runtimeStack_be string = 'Python|3.10'
param runtimeStack_fe string = 'Node|14-lts'
param startupCommand string = 'pm2 serve /home/site/wwwroot/dist --no-daemon --spa'

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

module appService1 'modules/appStuff_be.bicep' = if (environmentType == 'prod') {
  name: 'appService1'
  params: { 
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimeStack_be
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService3 'modules/appStuff_fe.bicep' = if (environmentType == 'prod') {
  name: 'appService3'
  params: { 
    location: location
    appServiceAppName: appServiceAppName3
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimeStack_fe
    startupCommand: startupCommand
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService2 'modules/appStuff_be.bicep' = if (environmentType == 'nonprod') {
  name: 'appService2'
  params: { 
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimeStack_be
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService4 'modules/appStuff_fe.bicep' = if (environmentType == 'nonprod') {
  name: 'appService4'
  params: { 
    location: location
    appServiceAppName: appServiceAppName4
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimeStack_fe
    startupCommand: startupCommand
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

  output appServiceAppHostName1 string = (environmentType == 'prod') ? appService1.outputs.appServiceAppHostName : appService2.outputs.appServiceAppHostName
  output appServiceAppHostName2 string = (environmentType == 'prod') ? appService3.outputs.appServiceAppHostName : appService4.outputs.appServiceAppHostName
    
