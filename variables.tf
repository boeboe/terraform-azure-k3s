######################
# Azure Infrastructure
######################

variable "az_resource_group" {
  description = "The name which should be used for this resource group."
  type        = string
}

variable "az_location" {
  description = "The Azure region where the resource group should exist."
  type        = string
}

variable "az_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "az_k3s_mysql_server_name" {
  description = "An Azure globally unique name of your K3S MySQL database."
  type        = string
}

variable "az_k3s_mysql_admin_username" {
  description = "Your K3S MySQL database admin username."
  type        = string
}

variable "az_k3s_mysql_admin_password" {
  description = "Your K3S MySQL database admin password."
  type        = string
}

variable "az_allow_public_ip" {
  description = "Your public IP address for Azure firewall access."
  type        = string
}


###################
# K3S Configuration
###################

variable "k3s_server_groups" {
  description = "A map of group specifications for K3S servers."
  type = map(object(
    {
      k3s_server_names        = list(string)
      k3s_server_vm_size      = string
      k3s_server_admin_user   = string
      k3s_server_disk_size_gb = number
      k3s_server_extra_tags   = map(string)
      k3s_server_node_label   = string
      k3s_server_node_taint   = string
    }
  ))
}

variable "k3s_agent_groups" {
  description = "A map of group specifications for K3S agents."
  type = map(object(
    {
      k3s_agent_names        = list(string)
      k3s_agent_vm_size      = string
      k3s_agent_admin_user   = string
      k3s_agent_disk_size_gb = number
      k3s_agent_extra_tags   = map(string)
      k3s_agent_node_label   = string
      k3s_agent_node_taint   = string
    }
  ))
  default = {}
}

variable "k3s_version" {
  description = "The K3s version."
  type        = string
}

variable "k3s_token" {
  description = "The K3s token, a shared secret used to join a server or agent to a cluster."
  type        = string
}

variable "k3s_kubeconfig_output" {
  description = "The local file to store K3s kubeconfig."
  type        = string
  default     = "/tmp/kubeconfig.yaml"
}

variable "k3s_cluster_domain" {
  description = "The K3s Cluster Domain (default: 'cluster.local')."
  type        = string
  default     = ""
}

variable "k3s_disable_component" {
  description = "Do not deploy packaged components and delete any deployed components (valid items: coredns, servicelb, traefik, local-storage, metrics-server)."
  type        = string
  default     = ""
}

variable "k3s_flannel_backend" {
  description = "One of 'none', 'vxlan', 'ipsec', 'host-gw', or 'wireguard' (default: 'vxlan')"
  type        = string
  default     = ""
}

variable "k3s_cluster_cidr" {
  description = "Network CIDR to use for pod IPs (default: '10.42.0.0/16')."
  type        = string
  default     = ""
}

variable "k3s_service_cidr" {
  description = "Network CIDR to use for services IPs (default: '10.43.0.0/16')."
  type        = string
  default     = ""
}

variable "k3s_cluster_dns" {
  description = "Cluster IP for coredns service. Should be in your service-cidr range (default: '10.43.0.10')."
  type        = string
  default     = ""
}
