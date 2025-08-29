variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "vnet_cidr" {}
variable "app_subnet_cidr" {}
variable "pe_subnet_cidr" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "${var.prefix}-app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_cidr]
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "${var.prefix}-pe-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.pe_subnet_cidr]
  # reserved for Private Endpoints
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "pe_subnet_id" {
  value = azurerm_subnet.pe_subnet.id
}
