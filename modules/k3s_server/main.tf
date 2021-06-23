data "template_file" "k3s_install_server" {
  template = file("${path.module}/templates/k3s-install-server.sh")

  vars = {
    k3s_version = var.k3s_version

    /* Logging configuration section */
    verbosity       = var.verbosity
    vmodule         = var.vmodule
    log             = var.log
    alsologtostderr = var.alsologtostderr

    /* Listener configuration section */
    bind_address      = var.bind_address
    https_listen_port = var.https_listen_port
    advertise_address = var.advertise_address
    advertise_port    = var.advertise_port
    tls_san           = var.tls_san

    /* Data configuration section */
    data_dir = var.data_dir

    /* Networking configuration section */
    cluster_cidr    = var.cluster_cidr
    service_cidr    = var.service_cidr
    cluster_dns     = var.cluster_dns
    cluster_domain  = var.cluster_domain
    flannel_backend = var.flannel_backend

    /* Cluster configuration section */
    token      = var.token
    token_file = var.token_file

    /* Client configuration section */
    write_kubeconfig      = var.write_kubeconfig
    write_kubeconfig_mode = var.write_kubeconfig_mode

    /* Flags configuration section */
    kube_apiserver_arg                = var.kube_apiserver_arg
    kube_scheduler_arg                = var.kube_scheduler_arg
    kube_controller_manager_arg       = var.kube_controller_manager_arg
    kube_cloud_controller_manager_arg = var.kube_cloud_controller_manager_arg

    /* Database configuration section */
    datastore_endpoint = var.datastore_endpoint
    datastore_cafile   = var.datastore_cafile
    datastore_certfile = var.datastore_certfile
    datastore_keyfile  = var.datastore_keyfile

    /* Storage configuration section */
    default_local_storage_path = var.default_local_storage_path

    /* Components configuration section */
    disable                  = var.disable
    disable_scheduler        = var.disable_scheduler
    disable_cloud_controller = var.disable_cloud_controller
    disable_network_policy   = var.disable_network_policy

    /* Agent/Node configuration section */
    node_name    = var.node_name
    with_node_id = var.with_node_id
    node_label   = var.node_label
    node_taint   = var.node_taint

    /* Agent/Runtime configuration section */
    docker                     = var.docker
    container_runtime_endpoint = var.container_runtime_endpoint
    pause_image                = var.pause_image
    private_registry           = var.private_registry

    /* Agent/Networking configuration section */
    node_ip          = var.node_ip
    node_external_ip = var.node_external_ip
    resolv_conf      = var.resolv_conf
    flannel_iface    = var.flannel_iface
    flannel_conf     = var.flannel_conf

    /* Agent/Flags configuration section */
    kubelet_arg    = var.kubelet_arg
    kube_proxy_arg = var.kube_proxy_arg

    /* Experimental configuration section */
    rootless           = var.rootless
    agent_token        = var.agent_token
    agent_token_file   = var.agent_token_file
    server             = var.server
    cluster_init       = var.cluster_init
    cluster_reset      = var.cluster_reset
    secrets_encryption = var.secrets_encryption

    /* Depricated configuration section */
    no_flannel     = var.no_flannel
    no_deploy      = var.no_deploy
    cluster_secret = var.cluster_secret
  }
}

resource "local_file" "generate_k3s_install_server_file" {
  content  = data.template_file.k3s_install_server.rendered
  filename = "/tmp/k3s-install-server.sh"
}
