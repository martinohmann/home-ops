output "master_nodes" {
  value = {
    for i in range(var.master_node_count) :
    (proxmox_vm_qemu.master[i].name) => local.master_node_ips[i]
  }
}

output "worker_nodes" {
  value = {
    for i in range(var.worker_node_count) :
    (proxmox_vm_qemu.worker[i].name) => local.worker_node_ips[i]
  }
}
