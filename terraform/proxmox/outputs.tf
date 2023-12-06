output "node_ips" {
  value = merge(module.k3s.vm_ips, module.unifi.vm_ips)
}
