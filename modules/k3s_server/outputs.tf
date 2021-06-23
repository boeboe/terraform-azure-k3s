output "cloud_init" {
  value = data.template_file.k3s_install_server.rendered
}
