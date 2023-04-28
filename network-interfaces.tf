resource "azurerm_network_interface" "jump-server-nics" {
  count               = length(var.ssh_usernames)
  name                = "jump-server-nic-${count.index}"
  location            = azurerm_resource_group.user-resource-groups[count.index].location
  resource_group_name = azurerm_resource_group.user-resource-groups[count.index].name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.jump-server-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump-server-pips[count.index].id
  }
}
