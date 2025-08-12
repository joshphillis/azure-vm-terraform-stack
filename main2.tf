# Public IP resource is defined in network2.tf
# Do not duplicate here

# Reference existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
  depends_on          = [data.azurerm_resource_group.rg]
}


# Subnet with service endpoint for storage
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
  service_endpoints    = ["Microsoft.Storage"]
  depends_on           = [azurerm_virtual_network.vnet]
}


