variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "app_subnet_id" {}
variable "storage_account_id" {}
variable "cosmos_account_name" {}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

resource "azurerm_app_service" "app" {
  name                = "${var.prefix}-webapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    linux_fx_version = "NODE|16-lts"
    # VNet integration uses swift connection below
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "STORAGE_ACCOUNT_NAME"     = var.storage_account_id # sample reference; in real app use managed identity token
    "COSMOS_ACCOUNT_NAME"      = var.cosmos_account_name
  }
}

# VNet Integration (Regional - Swift)
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_app_service.app.id
  subnet_id      = var.app_subnet_id
}

output "webapp_default_hostname" {
  value = azurerm_app_service.app.default_site_hostname
}

output "webapp_identity" {
  value = azurerm_app_service.app.identity[0].principal_id
}
