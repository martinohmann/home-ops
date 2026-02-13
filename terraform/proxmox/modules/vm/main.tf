locals {
  ipconfig = [
    for settings in var.network_interfaces :
    settings.gateway == null
    ? "ip=${settings.address}/${split("/", settings.network)[1]}"
    : "ip=${settings.address}/${split("/", settings.network)[1]},gw=${settings.gateway}"
  ]
}

module "mac_address" {
  count      = length(var.network_interfaces)
  source     = "../stable-mac-address"
  ip_address = var.network_interfaces[count.index].address
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  target_node = var.target_node

  clone = var.vm_template

  cores   = var.vm_settings.cores
  sockets = var.vm_settings.sockets
  memory  = var.vm_settings.memory
  scsihw  = "virtio-scsi-single"

  agent            = 1
  bios             = "ovmf"
  automatic_reboot = var.vm_settings.automatic_reboot
  onboot           = var.vm_settings.start_on_boot

  disk {
    iothread = 1
    type     = "virtio"
    storage  = var.vm_settings.storage_id
    size     = var.vm_settings.disk_size
  }

  dynamic "network" {
    for_each = var.network_interfaces

    content {
      bridge    = network.value.bridge
      firewall  = network.value.firewall
      link_down = false
      macaddr   = upper(module.mac_address[network.key].address)
      model     = "virtio"
      queues    = 0
      rate      = 0
      tag       = network.value.tag
    }
  }

  lifecycle {
    ignore_changes = [
      cicustom,
      qemu_os,
      tags,
      target_node
    ]
  }

  os_type = "cloud-init"
  ciuser  = var.vm_settings.user

  ipconfig0 = try(local.ipconfig[0], null)
  ipconfig1 = try(local.ipconfig[1], null)
  ipconfig2 = try(local.ipconfig[2], null)
  ipconfig3 = try(local.ipconfig[3], null)

  sshkeys    = var.authorized_keys
  nameserver = var.nameserver
}
