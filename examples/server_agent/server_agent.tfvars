######################
# Azure Infrastructure
######################

az_resource_group = "TfK3sRG-ServerAgent"
az_location       = "westeurope"

az_tags = {
  Terraform   = "true"
  Environment = "TerraformK3s-HA"
  Owner       = "Vivek S"
}

az_k3s_mysql_server_name    = "tf-k3s-mysql-sa"
az_k3s_mysql_admin_username = "myadmin"
az_k3s_mysql_admin_password = "Password123!"

az_allow_public_ip = "81.82.50.95"

###################
# K3S Configuration
###################

k3s_server_groups = {
  Server = {
    k3s_server_names        = ["Master1", "Master2"]
    k3s_server_vm_size      = "Standard_DS1_v2"
    k3s_server_admin_user   = "ubuntu"
    k3s_server_disk_size_gb = 30
    k3s_server_extra_tags   = { "Role" = "master" }
    k3s_server_node_label   = "node.kubernetes.io/role=master"
    k3s_server_node_taint   = "node-role.kubernetes.io/master=:NoSchedule"
  }
}

k3s_agent_groups = {
  Agent = {
    k3s_agent_names        = ["Worker1", "Worker2"]
    k3s_agent_vm_size      = "Standard_DS1_v2"
    k3s_agent_admin_user   = "ubuntu"
    k3s_agent_disk_size_gb = 30
    k3s_agent_extra_tags   = { "Role" = "worker" }
    k3s_agent_node_label   = "node.kubernetes.io/role=worker"
    k3s_agent_node_taint   = ""
  }
}

k3s_version = "v1.20.8+k3s1"
k3s_token   = "230D3530-9E4E-419A-AC37-F62069F00439"

k3s_disable_component = "traefik"

k3s_kubeconfig_output = "./output/server_agent/kubeconfig.yaml"
