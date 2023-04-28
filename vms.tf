resource "azurerm_linux_virtual_machine" "jump-server-vms" {
  count               = length(var.ssh_usernames)
  name                = "jump-server-${count.index}"
  location            = azurerm_resource_group.user-resource-groups[count.index].location
  resource_group_name = azurerm_resource_group.user-resource-groups[count.index].name
  size                = "Standard_D2s_v3"
  admin_username      = "${var.ssh_usernames[count.index]}"
  network_interface_ids = [
    azurerm_network_interface.jump-server-nics[count.index].id,
  ]

  depends_on = [
    azurerm_subnet_network_security_group_association.jump-server-nsg-assoc
  ]

  admin_ssh_key {
    username   = "${var.ssh_usernames[count.index]}"
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "${var.ssh_usernames[count.index]}"
    private_key = file("${var.ssh_private_key_path}")
    host        = azurerm_public_ip.jump-server-pips[count.index].ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir scripts"
    ]
  }

  provisioner "file" {
    source      = "scripts/"
    destination = "scripts"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
      chmod 755 scripts/*.sh

      scripts/install-tools.sh

      AZURE_SERVICE_PRINCIPAL_CLIENT_ID="${var.azure_service_principal_client_id}" \
        AZURE_SERVICE_PRINCIPAL_CLIENT_SECRET="${var.azure_service_principal_client_secret}" \
        AZURE_TENANT_ID="${var.azure_tenant_id}" \
        PIVNET_REFRESH_TOKEN="${var.pivnet_refresh_token}" \
        scripts/login.sh

      USERNAME="${var.ssh_usernames[count.index]}" \
        USER_RESOURCE_GROUP="${var.azure_user_resource_groups_prefix}-${var.ssh_usernames[count.index]}" \
        TANZU_REGISTRY_USERNAME="${var.tanzu_registry_username}" \
        TANZU_REGISTRY_PASSWORD="${var.tanzu_registry_password}" \
        DNS_ZONE_NAME="${var.dns_zone_name}" \
        DNS_ZONE_RESOURCE_GROUP="${var.dns_zone_resource_group}" \
        scripts/clone-and-setup-tap-made-simple.sh
EOF
    ]
  }
}