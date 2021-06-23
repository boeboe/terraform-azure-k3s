#!/bin/sh

INSTALL_SCRIPT=/tmp/install.sh
INSTALL_LOGS=/var/log/k3s-install-agent-output.log

if [ "${docker}" = "true" ] ; then
  echo "Installing docker" | tee -a $${INSTALL_LOGS}
  curl https://releases.rancher.com/install-docker/18.09.sh | sh | tee -a $${INSTALL_LOGS}
  sudo usermod -aG docker ubuntu | tee -a $${INSTALL_LOGS}
fi

curl -sfL https://get.k3s.io > $${INSTALL_SCRIPT}
chmod +x $${INSTALL_SCRIPT}

INSTALL_K3S_VERSION=${k3s_version}
INSTALL_K3S_EXEC=agent

### Logging configuration section
if [ ! -z "${verbosity}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} -v ${verbosity}" ; fi
if [ ! -z "${vmodule}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --vmodule ${vmodule}" ; fi
if [ ! -z "${log}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --log ${log}" ; fi
if [ "${alsologtostderr}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --alsologtostderr" ; fi

### Cluster configuration section
if [ ! -z "${token}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --token ${token}" ; fi
if [ ! -z "${token_file}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --token-file ${token_file}" ; fi
if [ ! -z "${server}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --server ${server}" ; fi

### Agent/Data configuration section
if [ ! -z "${data_dir}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --data-dir ${data_dir}" ; fi

### Agent/Node configuration section
if [ ! -z "${node_name}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --node-name ${node_name}" ; fi
if [ "${with_node_id}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --with-node-id" ; fi
if [ ! -z "${node_label}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --node-label ${node_label}" ; fi
if [ ! -z "${node_taint}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --node-taint ${node_taint}" ; fi

### Agent/Runtime configuration section
if [ "${docker}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --docker" ; fi
if [ ! -z "${container_runtime_endpoint}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --container-runtime-endpoint ${container_runtime_endpoint}" ; fi
if [ ! -z "${pause_image}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --pause-image ${pause_image}" ; fi
if [ ! -z "${private_registry}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --private-registry ${private_registry}" ; fi

### Agent/Networking configuration section
if [ ! -z "${node_ip}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --node-ip ${node_ip}" ; fi
if [ ! -z "${node_external_ip}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --node-external-ip ${node_external_ip}" ; fi
if [ ! -z "${resolv_conf}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --resolv-conf ${resolv_conf}" ; fi
if [ ! -z "${flannel_iface}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --flannel-iface ${flannel_iface}" ; fi
if [ ! -z "${flannel_conf}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --flannel-conf ${flannel_conf}" ; fi

### Agent/Flags configuration section
if [ ! -z "${kubelet_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kubelet-arg ${kubelet_arg}" ; fi
if [ ! -z "${kube_proxy_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kube-proxy-arg ${kube_proxy_arg}" ; fi

### Experimental configuration section
if [ "${rootless}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --rootless" ; fi

### Depricated configuration section
if [ "${no_flannel}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --no-flannel" ; fi
if [ ! -z "${cluster_secret}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-secret ${cluster_secret}" ; fi

echo "Arguments parsing finished. Going to run the following installation command: " | tee -a $${INSTALL_LOGS}
echo "INSTALL_K3S_VERSION=$${INSTALL_K3S_VERSION} INSTALL_K3S_EXEC=\"$${INSTALL_K3S_EXEC}\" $${INSTALL_SCRIPT} | tee -a $${INSTALL_LOGS}" | tee -a $${INSTALL_LOGS}

INSTALL_K3S_VERSION=$${INSTALL_K3S_VERSION} INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC}" $${INSTALL_SCRIPT} | tee -a $${INSTALL_LOGS}
