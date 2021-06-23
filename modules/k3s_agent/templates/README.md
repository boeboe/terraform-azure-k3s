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

## K3s Agent CLI Help

Online documented [here](https://rancher.com/docs/k3s/latest/en/installation/install-options/agent-config)

If an option appears in brackets below, for example [`$K3S_URL`], it means that the option can be passed in as an environment variable of that name.


``` console
NAME:
   k3s agent - Run node agent

USAGE:
   k3s agent [OPTIONS]

OPTIONS:
   -v value                            (logging) Number for the log level verbosity (default: 0)
   --vmodule value                     (logging) Comma-separated list of pattern=N settings for file-filtered logging
   --log value, -l value               (logging) Log to file
   --alsologtostderr                   (logging) Log to standard error as well as file (if set)
   --token value, -t value             (cluster) Token to use for authentication [$K3S_TOKEN]
   --token-file value                  (cluster) Token file to use for authentication [$K3S_TOKEN_FILE]
   --server value, -s value            (cluster) Server to connect to [$K3S_URL]
   --data-dir value, -d value          (agent/data) Folder to hold state (default: "/var/lib/rancher/k3s")
   --node-name value                   (agent/node) Node name [$K3S_NODE_NAME]
   --with-node-id                      (agent/node) Append id to node name
   --node-label value                  (agent/node) Registering and starting kubelet with set of labels
   --node-taint value                  (agent/node) Registering kubelet with set of taints
   --docker                            (agent/runtime) Use docker instead of containerd
   --container-runtime-endpoint value  (agent/runtime) Disable embedded containerd and use alternative CRI implementation
   --pause-image value                 (agent/runtime) Customized pause image for containerd or docker sandbox (default: "docker.io/rancher/pause:3.1")
   --private-registry value            (agent/runtime) Private registry configuration file (default: "/etc/rancher/k3s/registries.yaml")
   --node-ip value, -i value           (agent/networking) IP address to advertise for node
   --node-external-ip value            (agent/networking) External IP address to advertise for node
   --resolv-conf value                 (agent/networking) Kubelet resolv.conf file [$K3S_RESOLV_CONF]
   --flannel-iface value               (agent/networking) Override default flannel interface
   --flannel-conf value                (agent/networking) Override default flannel config file
   --kubelet-arg value                 (agent/flags) Customized flag for kubelet process
   --kube-proxy-arg value              (agent/flags) Customized flag for kube-proxy process
   --rootless                          (experimental) Run rootless
   --no-flannel                        (deprecated) use --flannel-backend=none
   --cluster-secret value              (deprecated) use --token [$K3S_CLUSTER_SECRET]
```