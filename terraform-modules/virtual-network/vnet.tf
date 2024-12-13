resource "azurerm_resource_group" "default" {
  name     = var.default_resource_group_name
  location = var.default_resource_group_location
}

resource "azurerm_network_security_group" "default" {
  name                = var.default_security_group_name
  location            = var.default_resource_group_location
  resource_group_name = var.default_resource_group_name
}

resource "azurerm_virtual_network" "default" {
  name                = var.default_virtual_network_name
  location            = var.default_resource_group_location
  resource_group_name = var.default_resource_group_name
  address_space       = var.default_virtual_network_address_space
  dns_servers         = var.default_dns_servers

  subnet {
    name             = var.subnet1
    address_prefixes = var.subnet1_address_prefixes
    security_group   = var.subnet1_azurerm_network_security_group
  }

  tags = {
    environment = var.environment
  }
}