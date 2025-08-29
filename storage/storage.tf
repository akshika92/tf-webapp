variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "pe_subnet_id" {}

resource "azurerm_storage_account" "storage" {
  name                     = lower(format("%s%s", var.prefix, "store"))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  blob_properties {
    delete_retention_policy {
      days = 7
      
    }
  }
}

resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.storage.id

  rule {
    name    = "lifecycle"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
      prefix_match = ["static/","logs/"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
    }
  }
}

# Private endpoint for storage (created by security module typically, but keeping reference)
output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
