metadata description = 'Demonstrate using multiple Azure subscriptions for different tenants in a multi-tenant solution'
targetScope = 'resourceGroup'

@description('Name of the resourceGroup to create the resources in')
param rgName string

@description('Name of the location to create the resources in')
param location string

res-open
