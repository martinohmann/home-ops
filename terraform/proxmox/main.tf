data "http" "github_keys" {
  url = "https://github.com/martinohmann.keys"
}

locals {
  lan_network         = "192.168.1.0/24"
  lan_network_gateway = cidrhost(local.lan_network, 1)
  svc_network         = "192.168.40.0/24"
  svc_network_gateway = cidrhost(local.svc_network, 1)
}

module "k3s" {
  source = "../modules/proxmox-vm-fleet"

  authorized_keys = data.http.github_keys.response_body
  name_prefix     = "k3s-"
  target_nodes    = ["pve-0", "pve-1"]

  nameserver            = local.svc_network_gateway
  network               = local.svc_network
  network_gateway       = local.svc_network_gateway
  network_hostnum_start = 10

  vm_count = 5
  vm_settings = {
    cores         = 2
    disk_size     = "50G"
    memory        = 8192
    network_tag   = 40
    sockets       = 1
    start_on_boot = true
    user          = "k3s"
  }
  vm_template = "ubuntu-cloud-init"
}

module "unifi" {
  source = "../modules/proxmox-vm-fleet"

  authorized_keys = data.http.github_keys.response_body
  name            = "unifi"
  target_nodes    = ["pve-1"]

  nameserver            = local.lan_network_gateway
  network               = local.lan_network
  network_gateway       = local.lan_network_gateway
  network_hostnum_start = 2

  vm_count = 1
  vm_settings = {
    cores         = 2
    disk_size     = "15G"
    memory        = 2048
    network_tag   = 1
    sockets       = 1
    start_on_boot = true
    user          = "unifi"
  }
  vm_template = "ubuntu-cloud-init"
}
