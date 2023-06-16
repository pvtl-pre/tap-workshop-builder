variable "azure_service_principal_client_id" {
  type = string
}

variable "azure_service_principal_client_secret" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "dns_zone_resource_group" {
  type = string
}

variable "ssh_usernames" {
  type = list(any)
}

variable "tanzu_network_refresh_token" {
  type = string
}

variable "tanzu_registry_username" {
  type = string
}

variable "tanzu_registry_password" {
  type = string
}

variable "admin_ssh_private_key_path" {
  type    = string
  default = "./generated/.ssh/admin_id_rsa"
}

variable "azure_location" {
  type    = string
  default = "southcentralus"
}

variable "azure_twb_resource_group_name" {
  type    = string
  default = "tap-workshop-builder"
}

variable "azure_user_resource_groups_prefix" {
  type    = string
  default = "tap-workshop"
}

variable "azure_vnet_name" {
  type    = string
  default = "tap-workshop-builder-vnet"
}

variable "azure_vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azure_jump_server_subnet_name" {
  type    = string
  default = "jump-server-subnet"
}

variable "azure_jump_server_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "azure_jump_server_nsg_name" {
  type    = string
  default = "jump-server-nsg"
}

variable "user_ssh_private_key_path" {
  type    = string
  default = "./generated/.ssh/user_id_rsa"
}
