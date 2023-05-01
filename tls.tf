resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "user" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "admin_ssh_key" {
  filename             = pathexpand(var.admin_ssh_private_key_path)
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.admin.private_key_pem
}

resource "local_sensitive_file" "user_ssh_key" {
  filename             = pathexpand(var.user_ssh_private_key_path)
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.user.private_key_pem
}
