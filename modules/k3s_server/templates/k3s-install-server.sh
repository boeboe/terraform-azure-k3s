#!/bin/sh

INSTALL_SCRIPT=/tmp/install.sh
INSTALL_LOGS=/var/log/k3s-install-server-output.log

if [ "${docker}" = "true" ] ; then
  echo "Installing docker" | tee -a $${INSTALL_LOGS}
  curl https://releases.rancher.com/install-docker/18.09.sh | sh  | tee -a $${INSTALL_LOGS}
  sudo usermod -aG docker ubuntu | tee -a $${INSTALL_LOGS}
fi

curl -sfL https://get.k3s.io > $${INSTALL_SCRIPT}
chmod +x $${INSTALL_SCRIPT}

INSTALL_K3S_VERSION=${k3s_version}
INSTALL_K3S_EXEC=server

### Logging configuration section
if [ ! -z "${verbosity}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} -v ${verbosity}" ; fi
if [ ! -z "${vmodule}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --vmodule ${vmodule}" ; fi
if [ ! -z "${log}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --log ${log}" ; fi
if [ "${alsologtostderr}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --alsologtostderr" ; fi

### Listener configuration section
if [ ! -z "${bind_address}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --bind-address ${bind_address}" ; fi
if [ ! -z "${https_listen_port}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --https-listen-port ${https_listen_port}" ; fi
if [ ! -z "${advertise_address}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --advertise-address ${advertise_address}" ; fi
if [ ! -z "${advertise_port}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --advertise-port ${advertise_port}" ; fi
if [ ! -z "${tls_san}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --tls-san ${tls_san}" ; fi

### Data configuration section
if [ ! -z "${data_dir}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --data-dir ${data_dir}" ; fi

### Networking configuration section
if [ ! -z "${cluster_cidr}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-cidr ${cluster_cidr}" ; fi
if [ ! -z "${service_cidr}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --service-cidr ${service_cidr}" ; fi
if [ ! -z "${cluster_dns}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-dns ${cluster_dns}" ; fi
if [ ! -z "${cluster_domain}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-domain ${cluster_domain}" ; fi
if [ ! -z "${flannel_backend}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --flannel-backend ${flannel_backend}" ; fi

### Cluster configuration section
if [ ! -z "${token}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --token ${token}" ; fi
if [ ! -z "${token_file}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --token-file ${token_file}" ; fi

### Client configuration section
if [ ! -z "${write_kubeconfig}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --write-kubeconfig ${write_kubeconfig}" ; fi
if [ ! -z "${write_kubeconfig_mode}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --write-kubeconfig-mode ${write_kubeconfig_mode}" ; fi

### Flags configuration section
if [ ! -z "${kube_apiserver_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kube-apiserver-arg ${kube_apiserver_arg}" ; fi
if [ ! -z "${kube_scheduler_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kube-scheduler-arg ${kube_scheduler_arg}" ; fi
if [ ! -z "${kube_controller_manager_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kube-controller-manager-arg ${kube_controller_manager_arg}" ; fi
if [ ! -z "${kube_cloud_controller_manager_arg}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --kube-cloud-controller-manager-arg ${kube_cloud_controller_manager_arg}" ; fi

### Database configuration section
if [ ! -z "${datastore_endpoint}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --datastore-endpoint ${datastore_endpoint}" ; fi
if [ ! -z "${datastore_cafile}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --datastore-cafile ${datastore_cafile}" ; fi
if [ ! -z "${datastore_certfile}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --datastore-certfile ${datastore_certfile}" ; fi
if [ ! -z "${datastore_keyfile}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --datastore-keyfile ${datastore_keyfile}" ; fi

### Storage configuration section
if [ ! -z "${default_local_storage_path}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --default-local-storage-path ${default_local_storage_path}" ; fi

### Components configuration section
if [ ! -z "${disable}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --disable ${disable}" ; fi
if [ "${disable_scheduler}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --disable-scheduler" ; fi
if [ "${disable_cloud_controller}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --disable-cloud-controller" ; fi
if [ "${disable_network_policy}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --disable-network-policy" ; fi

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
if [ ! -z "${agent_token}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --agent-token ${agent_token}" ; fi
if [ ! -z "${agent_token_file}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --agent-token-file ${agent_token_file}" ; fi
if [ ! -z "${server}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --server ${server}" ; fi
if [ "${cluster_init}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-init" ; fi
if [ "${cluster_reset}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-reset" ; fi
if [ "${secrets_encryption}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --secrets-encryption" ; fi

### Depricated configuration section
if [ "${no_flannel}" = "true" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --no-flannel" ; fi
if [ ! -z "${no_deploy}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --no-deploy ${no_deploy}" ; fi
if [ ! -z "${cluster_secret}" ] ; then INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC} --cluster-secret ${cluster_secret}" ; fi

echo "Arguments parsing finished. Going to run the following installation command: " | tee -a $${INSTALL_LOGS}
echo "INSTALL_K3S_VERSION=$${INSTALL_K3S_VERSION} INSTALL_K3S_EXEC=\"$${INSTALL_K3S_EXEC}\" $${INSTALL_SCRIPT} | tee -a $${INSTALL_LOGS}" | tee -a $${INSTALL_LOGS}

INSTALL_K3S_VERSION=$${INSTALL_K3S_VERSION} INSTALL_K3S_EXEC="$${INSTALL_K3S_EXEC}" $${INSTALL_SCRIPT} | tee -a $${INSTALL_LOGS}
