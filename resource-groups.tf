resource "azurerm_resource_group" "twb-resource-group" {
  name     = var.azure_twb_resource_group_name
  location = var.azure_location
}

resource "azurerm_resource_group" "user-resource-groups" {
  count    = length(var.ssh_usernames)
  name     = "${var.azure_user_resource_groups_prefix}-${var.ssh_usernames[count.index]}"
  location = var.azure_location
}
