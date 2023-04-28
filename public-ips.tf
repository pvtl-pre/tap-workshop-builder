resource "azurerm_public_ip" "jump-server-pips" {
  count               = length(var.ssh_usernames)
  name                = "jump-server-pip-${count.index}"
  location            = azurerm_resource_group.user-resource-groups[count.index].location
  resource_group_name = azurerm_resource_group.user-resource-groups[count.index].name
  allocation_method   = "Static"
  sku                 = "Standard"
}
