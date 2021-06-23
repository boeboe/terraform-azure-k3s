data "template_file" "k3s_install_agent" {
  template = file("${path.module}/templates/k3s-install-agent.sh")

  vars = {
    k3s_version = var.k3s_version

    /* Logging configuration section */
    verbosity       = var.verbosity
    vmodule         = var.vmodule
    log             = var.log
    alsologtostderr = var.alsologtostderr

    /* Cluster configuration section */
    token      = var.token
    token_file = var.token_file
    server     = var.server

    /* Data configuration section */
    data_dir = var.data_dir

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
    rootless = var.rootless

    /* Depricated configuration section */
    no_flannel     = var.no_flannel
    cluster_secret = var.cluster_secret
  }
}

resource "local_file" "generate_k3s_install_agent_file" {
  content  = data.template_file.k3s_install_agent.rendered
  filename = "/tmp/k3s-install-agent.sh"
}
