locals {
  network_cidr_bitnum = split("/", var.network)[1]
}

module "mac_address" {
  source     = "../stable-mac-address"
  ip_address = var.network_address
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  target_node = var.target_node

  clone = var.vm_template

  cores   = var.vm_settings.cores
  sockets = var.vm_settings.sockets
  memory  = var.vm_settings.memory
  scsihw  = "virtio-scsi-single"

  agent  = 1
  bios   = "ovmf"
  onboot = var.vm_settings.start_on_boot

  disk {
    iothread = 1
    type     = "virtio"
    storage  = var.vm_settings.storage_id
    size     = var.vm_settings.disk_size
  }

  network {
    bridge    = var.vm_settings.network_bridge
    firewall  = var.vm_settings.firewall
    link_down = false
    macaddr   = upper(module.mac_address.address)
    model     = "virtio"
    queues    = 0
    rate      = 0
    tag       = var.vm_settings.network_tag
  }

  lifecycle {
    ignore_changes = [
      cicustom,
      qemu_os,
      tags,
      target_node
    ]
  }

  os_type    = "cloud-init"
  ciuser     = var.vm_settings.user
  ipconfig0  = "ip=${var.network_address}/${local.network_cidr_bitnum},gw=${var.network_gateway}"
  sshkeys    = var.authorized_keys
  nameserver = var.nameserver
}
