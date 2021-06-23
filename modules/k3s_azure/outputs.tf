output "k3s_resource_group_name" {
  value = azurerm_resource_group.az_k3s_resource_group.name
}

output "k3s_resource_group_location" {
  value = azurerm_resource_group.az_k3s_resource_group.location
}

output "k3s_resource_nics" {
  value = azurerm_network_interface.az_k3s_nics
}

output "k3s_external_lb_ip" {
  value = azurerm_public_ip.az_k3s_public_ip_lb.ip_address
}

output "k3s_external_lb_fqdn" {
  value = azurerm_public_ip.az_k3s_public_ip_lb.fqdn
}

output "k3s_datastore_endpoint" {
  value = format("mysql://%s@%s:%s@tcp(%s.mysql.database.azure.com:3306)/kubernetes", var.az_k3s_mysql_admin_username, local.az_k3s_mysql_server_name, var.az_k3s_mysql_admin_password, local.az_k3s_mysql_server_name)
}
