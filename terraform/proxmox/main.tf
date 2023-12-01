data "http" "github_keys" {
  url = "https://github.com/martinohmann.keys"
}

locals {
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
