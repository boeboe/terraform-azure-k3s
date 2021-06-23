# terraform-azure-k3s

![Terraform Version](https://img.shields.io/badge/terraform-≥_1.0.0-blueviolet)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/boeboe/terraform-azure-k3s?label=registry)](https://registry.terraform.io/modules/boeboe/k3s/azure)
[![GitHub issues](https://img.shields.io/github/issues/boeboe/terraform-azure-k3s)](https://github.com/boeboe/terraform-azure-k3s/issues)
[![Open Source Helpers](https://www.codetriage.com/boeboe/terraform-azure-k3s/badges/users.svg)](https://www.codetriage.com/boeboe/terraform-azure-k3s)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Terraform module which creates a [k3s](https://k3s.io/) cluster, with multi-server 
and labels/taints management features, on azure cloud. 

## Usage

``` hcl
module "k3s" {
  source  = "boeboe/k3s/azure"
  version = "0.0.1"

  az_resource_group = "TestK3sRG-ServerAgentGroups"
  az_location       = "westeurope"

  az_tags = {
    Terraform   = "true"
    Environment = "MyTerraformTest"
    Owner       = "Bart Van Bos"
  }

  az_k3s_mysql_server_name    = "test-k3s-mysql-sag"
  az_k3s_mysql_admin_username = "myadmin"
  az_k3s_mysql_admin_password = "Password123!"

  az_allow_public_ip = "81.82.50.95"

  k3s_server_groups = {
    Master = {
      k3s_server_names        = ["Master1"]
      k3s_server_vm_size      = "Standard_DS1_v2"
      k3s_server_admin_user   = "ubuntu"
      k3s_server_disk_size_gb = 30
      k3s_server_extra_tags   = { "Role" = "master" }
      k3s_server_node_label   = "node.kubernetes.io/role=master"
      k3s_server_node_taint   = "node-role.kubernetes.io/master=:NoSchedule"
    }
  }

  k3s_agent_groups = {
    Worker = {
      k3s_agent_names        = ["Worker1"]
      k3s_agent_vm_size      = "Standard_DS1_v2"
      k3s_agent_admin_user   = "ubuntu"
      k3s_agent_disk_size_gb = 30
      k3s_agent_extra_tags   = { "Role" = "worker" }
      k3s_agent_node_label   = "node.kubernetes.io/role=worker"
      k3s_agent_node_taint   = ""
    }

    Infra = {
      k3s_agent_names        = ["Infra1"]
      k3s_agent_vm_size      = "Standard_DS1_v2"
      k3s_agent_admin_user   = "ubuntu"
      k3s_agent_disk_size_gb = 30
      k3s_agent_extra_tags   = { "Role" = "infra" }
      k3s_agent_node_label   = "node.kubernetes.io/role=infra"
      k3s_agent_node_taint   = "node.kubernetes.io/role=infra:NoSchedule"
    }
  }

  k3s_version = "v1.20.8+k3s1"
  k3s_token   = "230D3530-9E4E-419A-AC37-F62069F00439"

  k3s_disable_component = "traefik"
  k3s_kubeconfig_output = "./output/server_agent_groups/kubeconfig.yaml"
}
```

Check the [examples](examples) for more details.

## Inputs

### Azure related configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| az_resource_group | The name which should be used for this resource group | string | | true |
| az_location | The Azure region where the resource group should exist | string | | true |
| az_tags | A map of tags to add to all resources | map(string) | {} | false |
| az_k3s_mysql_server_name | An Azure globally unique name of your K3S MySQL database | string | | true |
| az_k3s_mysql_admin_username | Your K3S MySQL database admin username | string | | true |
| az_k3s_mysql_admin_password | Your K3S MySQL database admin password | string | | true |
| az_allow_public_ip | Your public IP address for Azure firewall access | string | | true |


### K3s related configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| k3s_server_groups | A map of group specifications for K3S servers | map | | true |
| k3s_agent_groups | A map of group specifications for K3S agents | map | {} | false |
| k3s_version | The K3s version | string | | true |
| k3s_token | The K3s token, a shared secret used to join a server or agent to a cluster | string | | true |
| k3s_kubeconfig_output | The local file to store K3s kubeconfig | string | "/tmp/kubeconfig.yaml" | false |
| k3s_cluster_domain | The K3s Cluster Domain | string | "cluster.local" | false |
| k3s_disable_component | Do not deploy packaged components and delete any deployed components (valid items: coredns, servicelb, traefik, local-storage, metrics-server) | string | "" | false |
| k3s_flannel_backend | One of "none", "vxlan", "ipsec", "host-gw" or "wireguard" | string | "vxlan" | false |
| k3s_cluster_cidr | Network CIDR to use for pod IPs | string | "10.42.0.0/16" | false |
| k3s_service_cidr | Network CIDR to use for services IPs | string | "10.43.0.0/16" | false |
| k3s_cluster_dns | Cluster IP for coredns service. Should be in your service-cidr range | string | "10.43.0.10" | false |


## Outputs

| Name | Description | Type |
|------|-------------|------|
| k3s_server_public_ips | Public IP addresses of the K3s servers | map(string) |
| k3s_agent_public_ips | Public IP addresses of the K3s agents | map(string) |
| k3s_external_lb_ip | Public IP addresses of the K3s LBs | string |
| k3s_external_lb_fqdn | Public FQDN of the K3s LBs | string |
| k3s_kubeconfig | Location of the kubeconfig file | string |
| k3s_cluster_state | Kubectl command to the K3s node status | string |
| k3s_kubectl_alias | Kubectl alias for the K3s cluster | string |


## More information

TBC

## License

terraform-azure-k3s is released under the **MIT License**. See the bundled [LICENSE](LICENSE) file for details.
