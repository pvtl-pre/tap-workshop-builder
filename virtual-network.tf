resource "azurerm_virtual_network" "vnet" {
  name                = var.azure_vnet_name
  location            = azurerm_resource_group.twb-resource-group.location
  resource_group_name = azurerm_resource_group.twb-resource-group.name
  address_space       = [var.azure_vnet_cidr]
}