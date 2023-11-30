output "vm_ips" {
  value = {
    for i, vm in proxmox_vm_qemu.vm : (vm.name) => local.vm_ips[i]
  }
}
