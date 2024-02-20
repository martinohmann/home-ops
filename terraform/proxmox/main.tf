data "http" "github_keys" {
  url = "https://github.com/martinohmann.keys"
}

locals {
  lan_network         = "192.168.1.0/24"
  lan_network_gateway = cidrhost(local.lan_network, 1)
  svc_network         = "192.168.40.0/24"
  svc_network_gateway = cidrhost(local.svc_network, 1)
  target_nodes        = ["pve-0", "pve-1", "pve-2"]
}

module "k3s" {
  source = "./modules/vm"

  count           = 3
  authorized_keys = data.http.github_keys.response_body
  name            = format("k3s-%d", count.index)
  target_node     = local.target_nodes[count.index % length(local.target_nodes)]

  nameserver      = local.svc_network_gateway
  network         = local.svc_network
  network_address = cidrhost(local.svc_network, count.index + 10)
  network_gateway = local.svc_network_gateway

  vm_settings = {
    automatic_reboot = false
    cores            = 4
    disk_size        = "150G"
    memory           = 20480
    network_tag      = 40
    sockets          = 1
    start_on_boot    = true
    user             = "k3s"
  }
  vm_template = "ubuntu-cloud-init"
}

module "unifi" {
  source = "./modules/vm"

  authorized_keys = data.http.github_keys.response_body
  name            = "unifi"
  target_node     = local.target_nodes[2]

  nameserver      = local.lan_network_gateway
  network         = local.lan_network
  network_address = cidrhost(local.lan_network, 2)
  network_gateway = local.lan_network_gateway

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
