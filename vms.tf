resource "azurerm_linux_virtual_machine" "jump-server-vms" {
  count               = length(var.ssh_usernames)
  name                = "jump-server-${count.index}"
  location            = azurerm_resource_group.user-resource-groups[count.index].location
  resource_group_name = azurerm_resource_group.user-resource-groups[count.index].name
  size                = "Standard_D2s_v3"
  admin_username      = "admin-${var.ssh_usernames[count.index]}"

  custom_data = base64encode(templatefile("./cloud-init/cloud-config.yaml", {
    admin_username                         = "admin-${var.ssh_usernames[count.index]}"
    username                               = var.ssh_usernames[count.index]
    admin_ssh_public_key                   = tls_private_key.admin.public_key_openssh
    ssh_public_key                         = tls_private_key.user.public_key_openssh
    azure_service_principal_client_id      = var.azure_service_principal_client_id
    azure_service_principal_client_secret  = var.azure_service_principal_client_secret
    azure_tenant_id                        = var.azure_tenant_id
    pivnet_refresh_token                   = var.pivnet_refresh_token
    azure_user_resource_groups_prefix      = var.azure_user_resource_groups_prefix
    tanzu_registry_username                = var.tanzu_registry_username
    tanzu_registry_password                = var.tanzu_registry_password
    dns_zone_name                          = var.dns_zone_name
    dns_zone_resource_group                = var.dns_zone_resource_group
    install_tools_script                   = base64encode(file("./scripts/install-tools.sh"))
    login_script                           = base64encode(file("./scripts/login.sh"))
    clone_and_setup_tap_made_simple_script = base64encode(file("./scripts/clone-and-setup-tap-made-simple.sh"))
  }))

  network_interface_ids = [
    azurerm_network_interface.jump-server-nics[count.index].id,
  ]

  depends_on = [
    azurerm_subnet_network_security_group_association.jump-server-nsg-assoc
  ]

  admin_ssh_key {
    username   = "admin-${var.ssh_usernames[count.index]}"
    public_key = tls_private_key.admin.public_key_openssh
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
}

resource "null_resource" "cloud-init-wait" {
  count = length(var.ssh_usernames)

  triggers = {
    instance_id = azurerm_linux_virtual_machine.jump-server-vms[count.index].id
  }

  connection {
    type        = "ssh"
    user        = "admin-${var.ssh_usernames[count.index]}"
    private_key = tls_private_key.admin.private_key_pem
    host        = azurerm_linux_virtual_machine.jump-server-vms[count.index].public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to finish'", 
      "cloud-init status --wait > /dev/null",
      "echo 'cloud-init finished'", 
      "cloud-init status",
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.jump-server-vms
  ]
}
