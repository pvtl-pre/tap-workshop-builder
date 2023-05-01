output "ssh_info" {
  value = <<EOF
    %{for i, name in var.ssh_usernames}
      ssh admin-${name}@${azurerm_linux_virtual_machine.jump-server-vms[i].public_ip_address} -i ${var.admin_ssh_private_key_path} -o StrictHostKeyChecking=no
      ssh       ${name}@${azurerm_linux_virtual_machine.jump-server-vms[i].public_ip_address} -i ${var.user_ssh_private_key_path} -o StrictHostKeyChecking=no
            
    %{endfor}
EOF

  description = "The ssh information for each user's and corresponding admin jump server instance."
}
