locals {
  proxmox_node_count = length(var.proxmox_nodes)

  lan_subnet_cidr_bitnum = split("/", var.lan_subnet)[1]

  master_node_ips = [for i in range(var.master_node_count) : cidrhost(var.control_plane_subnet, i)]
  worker_node_ips = [for i in range(var.worker_node_count) : cidrhost(var.worker_node_subnet, i)]
}

module "master-mac-address" {
  source = "../stable-mac-address"

  count      = var.master_node_count
  ip_address = local.master_node_ips[count.index]
}

resource "proxmox_vm_qemu" "master" {
  count = var.master_node_count

  name        = "${var.cluster_name}-master-${count.index + 1}"
  target_node = var.proxmox_nodes[count.index % local.proxmox_node_count]

  clone = coalesce(var.master_node_settings.template, var.node_template)

  cores   = var.master_node_settings.cores
  sockets = var.master_node_settings.sockets
  memory  = var.master_node_settings.memory
  scsihw  = "virtio-scsi-single"

  agent = 1

  disk {
    iothread = 1
    type     = "virtio"
    storage  = var.master_node_settings.storage_id
    size     = var.master_node_settings.disk_size
  }

  network {
    bridge    = var.master_node_settings.network_bridge
    firewall  = true
    link_down = false
    macaddr   = upper(module.master-mac-address[count.index].address)
    model     = "virtio"
    queues    = 0
    rate      = 0
    tag       = var.master_node_settings.network_tag
  }

  lifecycle {
    ignore_changes = [
      cicustom,
      qemu_os,
      tags
    ]
  }

  os_type    = "cloud-init"
  cicustom   = var.master_node_settings.cicustom
  ciuser     = var.master_node_settings.user
  ipconfig0  = "ip=${local.master_node_ips[count.index]}/${local.lan_subnet_cidr_bitnum},gw=${var.network_gateway}"
  sshkeys    = file(var.authorized_keys_file)
  nameserver = var.nameserver
}

module "worker-mac-address" {
  source = "../stable-mac-address"

  count      = var.worker_node_count
  ip_address = local.worker_node_ips[count.index]
}

resource "proxmox_vm_qemu" "worker" {
  count = var.worker_node_count

  name        = "${var.cluster_name}-worker-${count.index + 1}"
  target_node = var.proxmox_nodes[count.index % local.proxmox_node_count]

  clone = coalesce(var.worker_node_settings.template, var.node_template)

  cores   = var.worker_node_settings.cores
  sockets = var.worker_node_settings.sockets
  memory  = var.worker_node_settings.memory
  scsihw  = "virtio-scsi-single"

  agent = 1

  disk {
    iothread = 1
    type     = "virtio"
    storage  = var.worker_node_settings.storage_id
    size     = var.worker_node_settings.disk_size
  }

  network {
    bridge    = var.worker_node_settings.network_bridge
    firewall  = true
    link_down = false
    macaddr   = upper(module.worker-mac-address[count.index].address)
    model     = "virtio"
    queues    = 0
    rate      = 0
    tag       = var.worker_node_settings.network_tag
  }

  lifecycle {
    ignore_changes = [
      cicustom,
      qemu_os,
      tags
    ]
  }

  os_type    = "cloud-init"
  cicustom   = var.worker_node_settings.cicustom
  ciuser     = var.worker_node_settings.user
  ipconfig0  = "ip=${local.worker_node_ips[count.index]}/${local.lan_subnet_cidr_bitnum},gw=${var.network_gateway}"
  sshkeys    = file(var.authorized_keys_file)
  nameserver = var.nameserver
}
