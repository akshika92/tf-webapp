output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "app_service_default_hostname" {
  value = module.app.webapp_default_hostname
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "cosmos_account_name" {
  value = module.database.cosmos_account_name
}
