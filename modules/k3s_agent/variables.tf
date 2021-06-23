###################
# K3S Configuration
###################

variable "k3s_version" {
  description = "The K3s version."
  type        = string
}

###############################
# Logging configuration section
###############################

variable "verbosity" {
  type        = string
  default     = ""
  description = "Number for the log level verbosity (default: 0)"
}

variable "vmodule" {
  type        = string
  default     = ""
  description = "Comma-separated list of pattern=N settings for file-filtered logging"
}

variable "log" {
  type        = string
  default     = ""
  description = "Log to file"
}

variable "alsologtostderr" {
  type        = bool
  default     = false
  description = "Log to standard error as well as file (if set)"
}

###############################
# Cluster configuration section
###############################

variable "token" {
  type        = string
  default     = ""
  description = "Shared secret used to join a server or agent to a cluster [$K3S_TOKEN]"
}

variable "token_file" {
  type        = string
  default     = ""
  description = "File containing the cluster-secret/token [$K3S_TOKEN_FILE]"
}

variable "server" {
  type        = string
  default     = ""
  description = "Server to connect to [$K3S_URL]"
}

############################
# Data configuration section
############################

variable "data_dir" {
  type        = string
  default     = ""
  description = "Folder to hold state (default: /var/lib/rancher/k3s or $HOME/.rancher/k3s if not root)"
}

##################################
# Agent/Node configuration section
##################################

variable "node_name" {
  type        = string
  default     = ""
  description = "Node name [$K3S_NODE_NAME]"
}

variable "with_node_id" {
  type        = bool
  default     = false
  description = "Append id to node name"
}

variable "node_label" {
  type        = string
  default     = ""
  description = "Registering and starting kubelet with set of labels"
}

variable "node_taint" {
  type        = string
  default     = ""
  description = "Registering kubelet with set of taints"
}

#####################################
# Agent/Runtime configuration section
#####################################

variable "docker" {
  type        = bool
  default     = false
  description = "Use docker instead of containerd"
}

variable "container_runtime_endpoint" {
  type        = string
  default     = ""
  description = "Disable embedded containerd and use alternative CRI implementation"
}

variable "pause_image" {
  type        = string
  default     = ""
  description = "Customized pause image for containerd or docker sandbox (default: 'docker.io/rancher/pause:3.1')"
}

variable "private_registry" {
  type        = string
  default     = ""
  description = "Private registry configuration file (default: '/etc/rancher/k3s/registries.yaml')"
}

########################################
# Agent/Networking configuration section
########################################

variable "node_ip" {
  type        = string
  default     = ""
  description = "IP address to advertise for node"
}

variable "node_external_ip" {
  type        = string
  default     = ""
  description = "External IP address to advertise for node"
}

variable "resolv_conf" {
  type        = string
  default     = ""
  description = "Kubelet resolv.conf file [$K3S_RESOLV_CONF]"
}

variable "flannel_iface" {
  type        = string
  default     = ""
  description = "Override default flannel interface"
}

variable "flannel_conf" {
  type        = string
  default     = ""
  description = "Override default flannel config file"
}

###################################
# Agent/Flags configuration section
###################################

variable "kubelet_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kubelet process"
}

variable "kube_proxy_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kube-proxy process"
}

####################################
# Experimental configuration section
####################################

variable "rootless" {
  type        = bool
  default     = false
  description = "Run rootless"
}

####################################
# Depricated configuration section
####################################

variable "no_flannel" {
  type        = bool
  default     = false
  description = "(deprecated) use --flannel-backend=none"
}

variable "cluster_secret" {
  type        = string
  default     = ""
  description = "(deprecated) use --token [$K3S_CLUSTER_SECRET]"
}
