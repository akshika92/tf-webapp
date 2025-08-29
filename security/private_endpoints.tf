variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "webapp_identity" {}
variable "storage_account_id" {}

# Private Endpoint for Storage
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "${var.prefix}-pe-storage"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_account_id == "" ? "" : var.storage_account_id # placeholder; overridden by root module use
  private_service_connection {
    name                           = "storage-psc"
    is_manual_connection           = false
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
  }
}

# NOTE: In practice, call the private endpoint with the proper subnet id (use module.networking.pe_subnet_id).
# Also configure private DNS zones for blob and cosmos in a production setup.

# Role assignment: grant Storage Blob Data Contributor to the WebApp's managed identity
resource "azurerm_role_assignment" "webapp_storage_blob" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.webapp_identity
}
