# K3s Rancher installation documentation

Online documented [here](https://rancher.com/docs/k3s/latest/en/installation/install-options)

## Options for K3s Installation with Script

Online documented [here](https://rancher.com/docs/k3s/latest/en/installation/install-options/#options-for-installation-with-script)


``` console
curl -sfL https://get.k3s.io | sh -
```

When using this method to install K3s, the following environment variables can be used to configure the installation:

| ENVIRONMENT VARIABLE | DESCRIPTION |
|----------------------|-------------|
| INSTALL_K3S_SKIP_DOWNLOAD | If set to true will not download K3s hash or binary. |
| INSTALL_K3S_SYMLINK | By default will create symlinks for the kubectl, crictl, and ctr binaries if the commands do not already exist in path. If set to ‘skip’ will not create symlinks and ‘force’ will overwrite. |
| INSTALL_K3S_SKIP_ENABLE | If set to true will not enable or start K3s service. |
| INSTALL_K3S_SKIP_START | If set to true will not start K3s service. |
| INSTALL_K3S_VERSION | Version of K3s to download from Github. Will attempt to download from the stable channel if not specified. |
| INSTALL_K3S_BIN_DIR | Directory to install K3s binary, links, and uninstall script to, or use `/usr/local/bin` as the default. |
| INSTALL_K3S_BIN_DIR_READ_ONLY | If set to true will not write files to `INSTALL_K3S_BIN_DIR`, forces setting `INSTALL_K3S_SKIP_DOWNLOAD=true`. |
| INSTALL_K3S_SYSTEMD_DIR | Directory to install systemd service and environment files to, or use `/etc/systemd/system` as the default. |
| INSTALL_K3S_EXEC | Command with flags to use for launching K3s in the service. If the command is not specified, and the `K3S_URL` is set, it will default to “agent.” If `K3S_URL` not set, it will default to “server.” |
| INSTALL_K3S_NAME | Name of systemd service to create, will default to ‘k3s’ if running k3s as a server and ‘k3s-agent’ if running k3s as an agent. If specified the name will be prefixed with ‘k3s-’. |
| INSTALL_K3S_TYPE | Type of systemd service to create, will default from the K3s exec command if not specified. |
| INSTALL_K3S_SELINUX_WARN | If set to true will continue if k3s-selinux policy is not found. |
| INSTALL_K3S_SKIP_SELINUX_RPM | If set to true will skip automatic installation of the k3s RPM. |
| INSTALL_K3S_CHANNEL_URL | Channel URL for fetching K3s download URL. Defaults to https://update.k3s.io/v1-release/channels. |
| INSTALL_K3S_CHANNEL | Channel to use for fetching K3s download URL. Defaults to “stable”. Options include: `stable`, `latest`, `testing`. |

Environment variables which begin with `K3S_` will be preserved for the systemd and openrc services to use.

Setting `K3S_URL` without explicitly setting an exec command will default the command to “agent”.

When running the agent `K3S_TOKEN` must also be set.

## K3s Server CLI Help

Online documented [here](https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config)

If an option appears in brackets below, for example [`$K3S_TOKEN`], it means that the option can be passed in as an environment variable of that name.

``` console
NAME:
   k3s server - Run management server

USAGE:
   k3s server [OPTIONS]

OPTIONS:
   -v value                                   (logging) Number for the log level verbosity (default: 0)
   --vmodule value                            (logging) Comma-separated list of pattern=N settings for file-filtered logging
   --log value, -l value                      (logging) Log to file
   --alsologtostderr                          (logging) Log to standard error as well as file (if set)
   --bind-address value                       (listener) k3s bind address (default: 0.0.0.0)
   --https-listen-port value                  (listener) HTTPS listen port (default: 6443)
   --advertise-address value                  (listener) IP address that apiserver uses to advertise to members of the cluster (default: node-external-ip/node-ip)
   --advertise-port value                     (listener) Port that apiserver uses to advertise to members of the cluster (default: listen-port) (default: 0)
   --tls-san value                            (listener) Add additional hostname or IP as a Subject Alternative Name in the TLS cert
   --data-dir value, -d value                 (data) Folder to hold state default /var/lib/rancher/k3s or ${HOME}/.rancher/k3s if not root
   --cluster-cidr value                       (networking) Network CIDR to use for pod IPs (default: "10.42.0.0/16")
   --service-cidr value                       (networking) Network CIDR to use for services IPs (default: "10.43.0.0/16")
   --cluster-dns value                        (networking) Cluster IP for coredns service. Should be in your service-cidr range (default: 10.43.0.10)
   --cluster-domain value                     (networking) Cluster Domain (default: "cluster.local")
   --flannel-backend value                    (networking) One of 'none', 'vxlan', 'ipsec', 'host-gw', or 'wireguard' (default: "vxlan")
   --token value, -t value                    (cluster) Shared secret used to join a server or agent to a cluster [$K3S_TOKEN]
   --token-file value                         (cluster) File containing the cluster-secret/token [$K3S_TOKEN_FILE]
   --write-kubeconfig value, -o value         (client) Write kubeconfig for admin client to this file [$K3S_KUBECONFIG_OUTPUT]
   --write-kubeconfig-mode value              (client) Write kubeconfig with this mode [$K3S_KUBECONFIG_MODE]
   --kube-apiserver-arg value                 (flags) Customized flag for kube-apiserver process
   --kube-scheduler-arg value                 (flags) Customized flag for kube-scheduler process
   --kube-controller-manager-arg value        (flags) Customized flag for kube-controller-manager process
   --kube-cloud-controller-manager-arg value  (flags) Customized flag for kube-cloud-controller-manager process
   --datastore-endpoint value                 (db) Specify etcd, Mysql, Postgres, or Sqlite (default) data source name [$K3S_DATASTORE_ENDPOINT]
   --datastore-cafile value                   (db) TLS Certificate Authority file used to secure datastore backend communication [$K3S_DATASTORE_CAFILE]
   --datastore-certfile value                 (db) TLS certification file used to secure datastore backend communication [$K3S_DATASTORE_CERTFILE]
   --datastore-keyfile value                  (db) TLS key file used to secure datastore backend communication [$K3S_DATASTORE_KEYFILE]
   --default-local-storage-path value         (storage) Default local storage path for local provisioner storage class
   --disable value                            (components) Do not deploy packaged components and delete any deployed components (valid items: coredns, servicelb, traefik, local-storage, metrics-server)
   --disable-scheduler                        (components) Disable Kubernetes default scheduler
   --disable-cloud-controller                 (components) Disable k3s default cloud controller manager
   --disable-network-policy                   (components) Disable k3s default network policy controller
   --node-name value                          (agent/node) Node name [$K3S_NODE_NAME]
   --with-node-id                             (agent/node) Append id to node name
   --node-label value                         (agent/node) Registering and starting kubelet with set of labels
   --node-taint value                         (agent/node) Registering kubelet with set of taints
   --docker                                   (agent/runtime) Use docker instead of containerd
   --container-runtime-endpoint value         (agent/runtime) Disable embedded containerd and use alternative CRI implementation
   --pause-image value                        (agent/runtime) Customized pause image for containerd or docker sandbox (default: "docker.io/rancher/pause:3.1")
   --private-registry value                   (agent/runtime) Private registry configuration file (default: "/etc/rancher/k3s/registries.yaml")
   --node-ip value, -i value                  (agent/networking) IP address to advertise for node
   --node-external-ip value                   (agent/networking) External IP address to advertise for node
   --resolv-conf value                        (agent/networking) Kubelet resolv.conf file [$K3S_RESOLV_CONF]
   --flannel-iface value                      (agent/networking) Override default flannel interface
   --flannel-conf value                       (agent/networking) Override default flannel config file
   --kubelet-arg value                        (agent/flags) Customized flag for kubelet process
   --kube-proxy-arg value                     (agent/flags) Customized flag for kube-proxy process
   --rootless                                 (experimental) Run rootless
   --agent-token value                        (experimental/cluster) Shared secret used to join agents to the cluster, but not servers [$K3S_AGENT_TOKEN]
   --agent-token-file value                   (experimental/cluster) File containing the agent secret [$K3S_AGENT_TOKEN_FILE]
   --server value, -s value                   (experimental/cluster) Server to connect to, used to join a cluster [$K3S_URL]
   --cluster-init                             (experimental/cluster) Initialize new cluster master [$K3S_CLUSTER_INIT]
   --cluster-reset                            (experimental/cluster) Forget all peers and become a single cluster new cluster master [$K3S_CLUSTER_RESET]
   --secrets-encryption                       (experimental) Enable Secret encryption at rest
   --no-flannel                               (deprecated) use --flannel-backend=none
   --no-deploy value                          (deprecated) Do not deploy packaged components (valid items: coredns, servicelb, traefik, local-storage, metrics-server)
   --cluster-secret value                     (deprecated) use --token [$K3S_CLUSTER_SECRET]
```