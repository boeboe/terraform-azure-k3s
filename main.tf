######################
# Azure Infrastructure
######################

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
  k3s_server_groups_flatten = flatten([
    for k3s_server_group_key, k3s_server_group in var.k3s_server_groups : [
      for k3s_server_name in k3s_server_group.k3s_server_names : {
        k3s_server_group_name   = k3s_server_group_key
        k3s_server_name         = k3s_server_name
        k3s_server_vm_size      = k3s_server_group.k3s_server_vm_size
        k3s_server_admin_user   = k3s_server_group.k3s_server_admin_user
        k3s_server_disk_size_gb = k3s_server_group.k3s_server_disk_size_gb
        k3s_server_extra_tags   = k3s_server_group.k3s_server_extra_tags
        k3s_server_node_label   = k3s_server_group.k3s_server_node_label
        k3s_server_node_taint   = k3s_server_group.k3s_server_node_taint
      }
    ]
  ])

  k3s_agent_groups_flatten = flatten([
    for k3s_agent_group_key, k3s_agent_group in var.k3s_agent_groups : [
      for k3s_agent_name in k3s_agent_group.k3s_agent_names : {
        k3s_agent_group_name   = k3s_agent_group_key
        k3s_agent_name         = k3s_agent_name
        k3s_agent_vm_size      = k3s_agent_group.k3s_agent_vm_size
        k3s_agent_admin_user   = k3s_agent_group.k3s_agent_admin_user
        k3s_agent_disk_size_gb = k3s_agent_group.k3s_agent_disk_size_gb
        k3s_agent_extra_tags   = k3s_agent_group.k3s_agent_extra_tags
        k3s_agent_node_label   = k3s_agent_group.k3s_agent_node_label
        k3s_agent_node_taint   = k3s_agent_group.k3s_agent_node_taint
      }
    ]
  ])
}

module "k3s_azure" {
  source = "./modules/k3s_azure"

  az_resource_group  = var.az_resource_group
  az_location        = var.az_location
  az_tags            = var.az_tags
  az_allow_public_ip = var.az_allow_public_ip

  az_k3s_mysql_server_name    = var.az_k3s_mysql_server_name
  az_k3s_mysql_admin_username = var.az_k3s_mysql_admin_username
  az_k3s_mysql_admin_password = var.az_k3s_mysql_admin_password

  k3s_server_groups = var.k3s_server_groups
  k3s_agent_groups  = var.k3s_agent_groups
}

module "k3s_server" {
  source = "./modules/k3s_server"

  for_each = {
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_server_group_name}.${k3s_server.k3s_server_name}" => k3s_server
  }

  cluster_cidr          = var.k3s_cluster_cidr
  cluster_domain        = var.k3s_cluster_domain
  cluster_dns           = var.k3s_cluster_dns
  datastore_endpoint    = module.k3s_azure.k3s_datastore_endpoint
  disable               = var.k3s_disable_component
  flannel_backend       = var.k3s_flannel_backend
  k3s_version           = var.k3s_version
  node_label            = each.value.k3s_server_node_label
  node_taint            = each.value.k3s_server_node_taint
  service_cidr          = var.k3s_service_cidr
  tls_san               = module.k3s_azure.k3s_external_lb_ip
  token                 = var.k3s_token
  with_node_id          = true
  write_kubeconfig_mode = 644
}

resource "azurerm_linux_virtual_machine" "az_k3s_server_vms" {
  for_each = {
    for k3s_server in local.k3s_server_groups_flatten : "${k3s_server.k3s_server_group_name}.${k3s_server.k3s_server_name}" => k3s_server
  }

  name                = format("RancherK3sVm-%s.%s", each.value.k3s_server_group_name, each.value.k3s_server_name)
  resource_group_name = module.k3s_azure.k3s_resource_group_name
  location            = module.k3s_azure.k3s_resource_group_location
  size                = each.value.k3s_server_vm_size
  admin_username      = each.value.k3s_server_admin_user
  custom_data         = base64encode(module.k3s_server[each.key].cloud_init)

  network_interface_ids = [
    module.k3s_azure.k3s_resource_nics[each.key].id,
  ]

  admin_ssh_key {
    username   = each.value.k3s_server_admin_user
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = each.value.k3s_server_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = merge(
    var.az_tags,
    each.value.k3s_server_extra_tags
  )

  depends_on = [
    module.k3s_azure
  ]
}

module "k3s_agent" {
  source = "./modules/k3s_agent"

  for_each = {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_agent_group_name}.${k3s_agent.k3s_agent_name}" => k3s_agent
  }

  k3s_version  = var.k3s_version
  node_label   = each.value.k3s_agent_node_label
  node_taint   = each.value.k3s_agent_node_taint
  server       = format("https://%s:6443", module.k3s_azure.k3s_external_lb_ip)
  token        = var.k3s_token
  with_node_id = true
}

resource "azurerm_linux_virtual_machine" "az_k3s_agent_vms" {
  for_each = {
    for k3s_agent in local.k3s_agent_groups_flatten : "${k3s_agent.k3s_agent_group_name}.${k3s_agent.k3s_agent_name}" => k3s_agent
  }

  name                = format("RancherK3sVm-%s.%s", each.value.k3s_agent_group_name, each.value.k3s_agent_name)
  resource_group_name = module.k3s_azure.k3s_resource_group_name
  location            = module.k3s_azure.k3s_resource_group_location
  size                = each.value.k3s_agent_vm_size
  admin_username      = each.value.k3s_agent_admin_user
  custom_data         = base64encode(module.k3s_agent[each.key].cloud_init)

  network_interface_ids = [
    module.k3s_azure.k3s_resource_nics[each.key].id,
  ]

  admin_ssh_key {
    username   = each.value.k3s_agent_admin_user
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = each.value.k3s_agent_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = merge(
    var.az_tags,
    each.value.k3s_agent_extra_tags
  )

  depends_on = [
    module.k3s_azure
  ]
}

resource "null_resource" "kubeconfig" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = format("until ssh %s@%s true >/dev/null 2>&1 ; do sleep 5 ; done",
      lookup(azurerm_linux_virtual_machine.az_k3s_server_vms,
      "${local.k3s_server_groups_flatten[0].k3s_server_group_name}.${local.k3s_server_groups_flatten[0].k3s_server_name}").admin_username,
      lookup(azurerm_linux_virtual_machine.az_k3s_server_vms,
    "${local.k3s_server_groups_flatten[0].k3s_server_group_name}.${local.k3s_server_groups_flatten[0].k3s_server_name}").public_ip_address)
  }

  provisioner "local-exec" {
    command = format("ssh %s@%s \"while [ ! -f /etc/rancher/k3s/k3s.yaml ] ; do sleep 5 ; done ; cat /etc/rancher/k3s/k3s.yaml\" | sed \"s|127.0.0.1|%s|g\" > %s",
      lookup(azurerm_linux_virtual_machine.az_k3s_server_vms,
      "${local.k3s_server_groups_flatten[0].k3s_server_group_name}.${local.k3s_server_groups_flatten[0].k3s_server_name}").admin_username,
      lookup(azurerm_linux_virtual_machine.az_k3s_server_vms,
      "${local.k3s_server_groups_flatten[0].k3s_server_group_name}.${local.k3s_server_groups_flatten[0].k3s_server_name}").public_ip_address,
      module.k3s_azure.k3s_external_lb_ip,
    var.k3s_kubeconfig_output)
  }

  depends_on = [
    azurerm_linux_virtual_machine.az_k3s_server_vms
  ]
}

# Steps
# export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
# helm upgrade --install cert-manager jetstack/cert-manager   --namespace cert-manager   --create-namespace   --version v1.5.1