output "k3s_server_public_ips" {
  description = "Public IP addresses of the K3s servers"
  value = tomap({
    for k, k3s_server_vm in azurerm_linux_virtual_machine.az_k3s_server_vms : k => k3s_server_vm.public_ip_address
  })
}

output "k3s_agent_public_ips" {
  description = "Public IP addresses of the K3s agents"
  value = tomap({
    for k, k3s_agent_vm in azurerm_linux_virtual_machine.az_k3s_agent_vms : k => k3s_agent_vm.public_ip_address
  })
}

output "k3s_external_lb_ip" {
  description = "Public IP addresses of the K3s LBs"
  value       = module.k3s_azure.k3s_external_lb_ip
}

output "k3s_external_lb_fqdn" {
  description = "Public FQDN of the K3s LBs"
  value       = module.k3s_azure.k3s_external_lb_fqdn
}

output "k3s_kubeconfig" {
  description = "Location of the kubeconfig file"
  value       = var.k3s_kubeconfig_output
}

output "k3s_cluster_state" {
  description = "Kubectl command to the K3s node status"
  value       = format("kubectl --kubeconfig %s get nodes -o wide", var.k3s_kubeconfig_output)
}

output "k3s_kubectl_alias" {
  description = "Kubectl alias for the K3s cluster"
  value       = format("alias k3ctl='kubectl --kubeconfig %s '", var.k3s_kubeconfig_output)
}
