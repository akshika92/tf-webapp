variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "cosmos_capacity" {}
variable "pe_subnet_id" {}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "${var.prefix}-cosmos"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Session"
  }

  capabilities {
    name = "EnableMongo"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  automatic_failover_enabled = true

  
}

output "cosmos_account_name" {
  value = azurerm_cosmosdb_account.cosmos.name
}

output "cosmos_account_endpoint" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}
