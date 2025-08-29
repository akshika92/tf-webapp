variable "prefix" {
  type    = string
  default = "testweb"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "tf-proj"
  
}

variable "vnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "app_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "pe_subnet_cidr" {
  type    = string
  default = "10.10.2.0/24"
}

variable "app_service_sku" {
  type    = string
  default = "P1v2"
}

variable "cosmos_capacity" {
  type    = number
  default = 400
}
