######################
# Azure Infrastructure
######################

resource "random_id" "mysql_id" {
  keepers = {
    ami_id = "${var.az_k3s_mysql_server_name}"
  }

  byte_length = 2
}

locals {
  az_k3s_mysql_server_name = format("%s-%s", var.az_k3s_mysql_server_name, lower(random_id.mysql_id.hex))

  k3s_server_groups_flatten = flatten([
    for k3s_server_group_key, k3s_server_group in var.k3s_server_groups : [
      for k3s_server_name in k3s_server_group.k3s_server_names : {
        k3s_instance_group_name = k3s_server_group_key
        k3s_instance_name       = k3s_server_name
        k3s_instance_extra_tags = k3s_server_group.k3s_server_extra_tags
      }
    ]
  ])

  k3s_agent_groups_flatten = flatten([
    for k3s_agent_group_key, k3s_agent_group in var.k3s_agent_groups : [
      for k3s_agent_name in k3s_agent_group.k3s_agent_names : {
        k3s_instance_group_name = k3s_agent_group_key
        k3s_instance_name       = k3s_agent_name
        k3s_instance_extra_tags = k3s_agent_group.k3s_agent_extra_tags
      }
    ]
  ])
}

resource "azurerm_resource_group" "az_k3s_resource_group" {
  name     = var.az_resource_group
  location = var.az_location
  tags     = var.az_tags
}

resource "azurerm_virtual_network" "az_k3s_vnet" {
  name                = "TFK3sVnet"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location
  address_space       = ["10.0.0.0/16"]
  tags                = var.az_tags
}

resource "azurerm_public_ip" "az_k3s_public_ip" {
  for_each = merge({
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_instance_group_name}.${k3s_server.k3s_instance_name}" => k3s_server
    }, {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_instance_group_name}.${k3s_agent.k3s_instance_name}" => k3s_agent
  })

  name                = format("TFK3sPublicIp-%s", each.key)
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    var.az_tags,
    each.value.k3s_instance_extra_tags
  )
}

resource "azurerm_public_ip" "az_k3s_public_ip_lb" {
  name                = "TFK3sPublicIp-LoadBalancer"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.az_tags
  domain_name_label   = "tf-az-k3s-lb"
}

resource "azurerm_network_security_group" "az_k3s_nsg" {
  name                = "TFK3sNsg"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location
  tags                = var.az_tags

  security_rule {
    name                       = "TFK3sNsgRuleSsh"
    description                = "Allow SSH Access to all VMS."
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "TFK3sNsgHttp80Rule"
    description                = "Allow HTTP/80 to all VMS."
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "TFK3sNsgHttps443Rule"
    description                = "Allow HTTPS/443 to all VMS."
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "TFK3sNsgHttps6443Rule"
    description                = "Allow HTTPS/6443 to all VMS."
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "6443"
  }
}

resource "azurerm_lb" "az_k3s_lb" {
  name                = "TFK3sLoadBalancer"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location
  sku                 = "Standard"
  tags                = var.az_tags

  frontend_ip_configuration {
    name                 = "TFK3sFrontEndLbIp"
    public_ip_address_id = azurerm_public_ip.az_k3s_public_ip_lb.id
  }

  lifecycle {
    ignore_changes = [
      frontend_ip_configuration["private_ip_address_version"],
    ]
  }
}

resource "azurerm_lb_backend_address_pool" "az_k3s_lb_backend_pool_api" {
  loadbalancer_id = azurerm_lb.az_k3s_lb.id
  name            = "TFK3sBackEndPoolApi"

  lifecycle {
    ignore_changes = [
      # Ignore backend_address list, as this is assigned through NIC association
      backend_address,
    ]
  }
}

resource "azurerm_lb_backend_address_pool" "az_k3s_lb_backend_pool_traffic" {
  loadbalancer_id = azurerm_lb.az_k3s_lb.id
  name            = "TFK3sBackEndPoolTraffic"

  lifecycle {
    ignore_changes = [
      # Ignore backend_address list, as this is assigned through NIC association
      backend_address,
    ]
  }
}

resource "azurerm_lb_probe" "az_k3s_lb_probe_80" {
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id     = azurerm_lb.az_k3s_lb.id
  name                = "TFK3sLbProbe80"
  port                = 80
}

resource "azurerm_lb_probe" "az_k3s_lb_probe_443" {
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id     = azurerm_lb.az_k3s_lb.id
  name                = "TFK3sLbProbe443"
  port                = 443
}

resource "azurerm_lb_probe" "az_k3s_lb_probe_6443" {
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id     = azurerm_lb.az_k3s_lb.id
  name                = "TFK3sLbProbe6443"
  port                = 6443
}

resource "azurerm_lb_rule" "az_k3s_lb_rule_http80" {
  resource_group_name            = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id                = azurerm_lb.az_k3s_lb.id
  name                           = "TFK3sLbHttp80Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "TFK3sFrontEndLbIp"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.az_k3s_lb_backend_pool_traffic.id
  probe_id                       = azurerm_lb_probe.az_k3s_lb_probe_80.id
}

resource "azurerm_lb_rule" "az_k3s_lb_rule_https443" {
  resource_group_name            = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id                = azurerm_lb.az_k3s_lb.id
  name                           = "TFK3sLbHttps443Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "TFK3sFrontEndLbIp"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.az_k3s_lb_backend_pool_traffic.id
  probe_id                       = azurerm_lb_probe.az_k3s_lb_probe_443.id
}

resource "azurerm_lb_rule" "az_k3s_lb_rule_https6443" {
  resource_group_name            = azurerm_resource_group.az_k3s_resource_group.name
  loadbalancer_id                = azurerm_lb.az_k3s_lb.id
  name                           = "TFK3sLbHttps6443Rule"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "TFK3sFrontEndLbIp"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.az_k3s_lb_backend_pool_api.id
  probe_id                       = azurerm_lb_probe.az_k3s_lb_probe_6443.id
}

resource "azurerm_mysql_server" "az_k3s_mysql_server" {
  name                         = local.az_k3s_mysql_server_name
  resource_group_name          = azurerm_resource_group.az_k3s_resource_group.name
  location                     = azurerm_resource_group.az_k3s_resource_group.location
  version                      = "5.7"
  storage_mb                   = 51200
  sku_name                     = "GP_Gen5_2"
  administrator_login          = var.az_k3s_mysql_admin_username
  administrator_login_password = var.az_k3s_mysql_admin_password
  ssl_enforcement_enabled      = false
}

resource "azurerm_mysql_database" "az_k3s_mysql_database" {
  name                = "kubernetes"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  server_name         = azurerm_mysql_server.az_k3s_mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  depends_on = [
    azurerm_mysql_database.az_k3s_mysql_database
  ]
}

resource "azurerm_mysql_firewall_rule" "az_k3s_mysql_fw_rule_azure_ips" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  server_name         = azurerm_mysql_server.az_k3s_mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [
    azurerm_mysql_database.az_k3s_mysql_database
  ]
}

resource "azurerm_mysql_firewall_rule" "az_k3s_mysql_fw_rule_my_ip" {
  name                = "AllowPublicIp"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  server_name         = azurerm_mysql_server.az_k3s_mysql_server.name
  start_ip_address    = var.az_allow_public_ip
  end_ip_address      = var.az_allow_public_ip
}

resource "azurerm_subnet" "az_k3s_subnet" {
  name                 = "TFK3sSubnet"
  resource_group_name  = azurerm_resource_group.az_k3s_resource_group.name
  virtual_network_name = azurerm_virtual_network.az_k3s_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_mysql_virtual_network_rule" "az_k3s_mysql_vnet_rule" {
  name                = "TFK3sVNetRule"
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  server_name         = azurerm_mysql_server.az_k3s_mysql_server.name
  subnet_id           = azurerm_subnet.az_k3s_subnet.id
}

resource "azurerm_network_interface" "az_k3s_nics" {
  for_each = merge({
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_instance_group_name}.${k3s_server.k3s_instance_name}" => k3s_server
    }, {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_instance_group_name}.${k3s_agent.k3s_instance_name}" => k3s_agent
  })

  name                = format("TFK3sNic-%s", each.key)
  resource_group_name = azurerm_resource_group.az_k3s_resource_group.name
  location            = azurerm_resource_group.az_k3s_resource_group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.az_k3s_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az_k3s_public_ip[each.key].id
  }

  tags = merge(
    var.az_tags,
    each.value.k3s_instance_extra_tags
  )
}

resource "azurerm_network_interface_security_group_association" "az_k3s_nic_sec_group" {
  for_each = merge({
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_instance_group_name}.${k3s_server.k3s_instance_name}" => k3s_server
    }, {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_instance_group_name}.${k3s_agent.k3s_instance_name}" => k3s_agent
  })

  network_interface_id      = azurerm_network_interface.az_k3s_nics[each.key].id
  network_security_group_id = azurerm_network_security_group.az_k3s_nsg.id
}

resource "azurerm_network_interface_backend_address_pool_association" "az_k3s_nic_backend_address_pool_traffic" {
  for_each = merge({
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_instance_group_name}.${k3s_server.k3s_instance_name}" => k3s_server
    }, {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_instance_group_name}.${k3s_agent.k3s_instance_name}" => k3s_agent
  })

  network_interface_id    = azurerm_network_interface.az_k3s_nics[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.az_k3s_lb_backend_pool_traffic.id
}

resource "azurerm_network_interface_backend_address_pool_association" "az_k3s_nic_backend_address_pool_api" {
  for_each = {
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_instance_group_name}.${k3s_server.k3s_instance_name}" => k3s_server
  }

  network_interface_id    = azurerm_network_interface.az_k3s_nics[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.az_k3s_lb_backend_pool_api.id
}
