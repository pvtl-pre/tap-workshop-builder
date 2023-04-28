resource "azurerm_dns_a_record" "iterate-a-records" {
  count               = length(var.ssh_usernames)
  name                = "*.iterate.${var.ssh_usernames[count.index]}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  records             = ["0.0.0.0"]
}

resource "azurerm_dns_a_record" "learningcenter-a-records" {
  count               = length(var.ssh_usernames)
  name                = "*.learningcenter.${var.ssh_usernames[count.index]}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  records             = ["0.0.0.0"]
}

resource "azurerm_dns_a_record" "prod-a-records" {
  count               = length(var.ssh_usernames)
  name                = "*.prod.${var.ssh_usernames[count.index]}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  records             = ["0.0.0.0"]
}

resource "azurerm_dns_a_record" "tap-a-records" {
  count               = length(var.ssh_usernames)
  name                = "*.tap.${var.ssh_usernames[count.index]}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  records             = ["0.0.0.0"]
}
