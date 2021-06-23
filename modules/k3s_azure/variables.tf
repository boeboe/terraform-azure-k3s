######################
# Azure Infrastructure
######################

variable "az_resource_group" {
  description = "The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
  type        = string
}

variable "az_location" {
  description = "The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  type        = string
}

variable "az_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "az_k3s_mysql_server_name" {
  description = "An Azure globally unique name of your K3S MySQL Database."
  type        = string
}

variable "az_k3s_mysql_admin_username" {
  description = "Your K3S MySQL Database admin username."
  type        = string
}

variable "az_k3s_mysql_admin_password" {
  description = "Your K3S MySQL Database admin password."
  type        = string
}

variable "az_allow_public_ip" {
  description = "Your Public IP address for Azure Firewall Access."
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
}
