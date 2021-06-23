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

################################
# Listener configuration section
################################

variable "bind_address" {
  type        = string
  default     = ""
  description = "K3s bind address (default: 0.0.0.0)"
}

variable "https_listen_port" {
  type        = string
  default     = ""
  description = "HTTPS listen port (default: 6443)"
}

variable "advertise_address" {
  type        = string
  default     = ""
  description = "IP address that apiserver uses to advertise to members of the cluster (default: node-external-ip/node-ip)"
}

variable "advertise_port" {
  type        = string
  default     = ""
  description = "Port that apiserver uses to advertise to members of the cluster (default: listen-port) (default: 0)"
}

variable "tls_san" {
  type        = string
  default     = ""
  description = "Add additional hostname or IP as a Subject Alternative Name in the TLS cert"
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
# Networking configuration section
##################################

variable "cluster_cidr" {
  type        = string
  default     = ""
  description = "Network CIDR to use for pod IPs (default: '10.42.0.0/16')"
}

variable "service_cidr" {
  type        = string
  default     = ""
  description = "Network CIDR to use for services IPs (default: '10.43.0.0/16')"
}

variable "cluster_dns" {
  type        = string
  default     = ""
  description = "Cluster IP for coredns service. Should be in your service-cidr range (default: '10.43.0.10')"
}

variable "cluster_domain" {
  type        = string
  default     = ""
  description = "Cluster Domain (default: 'cluster.local')"
}

variable "flannel_backend" {
  type        = string
  default     = ""
  description = "One of 'none', 'vxlan', 'ipsec', 'host-gw', or 'wireguard' (default: 'vxlan')"
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

##############################
# Client configuration section
##############################

variable "write_kubeconfig" {
  type        = string
  default     = ""
  description = "Write kubeconfig for admin client to this file [$K3S_KUBECONFIG_OUTPUT]"
}

variable "write_kubeconfig_mode" {
  type        = string
  default     = ""
  description = "Write kubeconfig with this mode [$K3S_KUBECONFIG_MODE]"
}

#############################
# Flags configuration section
#############################

variable "kube_apiserver_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kube-apiserver process"
}

variable "kube_scheduler_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kube-scheduler process"
}

variable "kube_controller_manager_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kube-controller-manager process"
}

variable "kube_cloud_controller_manager_arg" {
  type        = string
  default     = ""
  description = "Customized flag for kube-cloud-controller-manager process"
}

################################
# Database configuration section
################################

variable "datastore_endpoint" {
  type        = string
  default     = ""
  description = "Specify etcd, Mysql, Postgres, or Sqlite (default) data source name [$K3S_DATASTORE_ENDPOINT]"
}

variable "datastore_cafile" {
  type        = string
  default     = ""
  description = "TLS Certificate Authority file used to secure datastore backend communication [$K3S_DATASTORE_CAFILE]"
}

variable "datastore_certfile" {
  type        = string
  default     = ""
  description = "TLS certification file used to secure datastore backend communication [$K3S_DATASTORE_CERTFILE]"
}

variable "datastore_keyfile" {
  type        = string
  default     = ""
  description = "TLS key file used to secure datastore backend communication [$K3S_DATASTORE_KEYFILE]"
}

###############################
# Storage configuration section
###############################

variable "default_local_storage_path" {
  type        = string
  default     = ""
  description = "Default local storage path for local provisioner storage class"
}

##################################
# Components configuration section
##################################

variable "disable" {
  type        = string
  default     = ""
  description = "Do not deploy packaged components and delete any deployed components (valid items: coredns, servicelb, traefik, local-storage, metrics-server)"
}

variable "disable_scheduler" {
  type        = bool
  default     = false
  description = "Disable Kubernetes default scheduler"
}

variable "disable_cloud_controller" {
  type        = bool
  default     = false
  description = "Disable k3s default cloud controller manager"
}

variable "disable_network_policy" {
  type        = bool
  default     = false
  description = "Disable k3s default network policy controller"
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

variable "agent_token" {
  type        = string
  default     = ""
  description = "Shared secret used to join agents to the cluster, but not servers [$K3S_AGENT_TOKEN]"
}

variable "agent_token_file" {
  type        = string
  default     = ""
  description = "File containing the agent secret [$K3S_AGENT_TOKEN_FILE]"
}

variable "server" {
  type        = string
  default     = ""
  description = "Server to connect to, used to join a cluster [$K3S_URL]"
}

variable "cluster_init" {
  type        = bool
  default     = false
  description = "Initialize new cluster master [$K3S_CLUSTER_INIT]"
}

variable "cluster_reset" {
  type        = bool
  default     = false
  description = "Forget all peers and become a single cluster new cluster master [$K3S_CLUSTER_RESET]"
}

variable "secrets_encryption" {
  type        = bool
  default     = false
  description = "Enable Secret encryption at rest"
}

####################################
# Depricated configuration section
####################################

variable "no_flannel" {
  type        = bool
  default     = false
  description = "(deprecated) use --flannel-backend=none"
}

variable "no_deploy" {
  type        = string
  default     = ""
  description = "(deprecated) Do not deploy packaged components (valid items: coredns, servicelb, traefik, local-storage, metrics-server)"
}

variable "cluster_secret" {
  type        = string
  default     = ""
  description = "(deprecated) use --token [$K3S_CLUSTER_SECRET]"
}
