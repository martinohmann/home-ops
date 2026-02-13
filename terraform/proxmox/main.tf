data "http" "github_keys" {
  url = "https://github.com/martinohmann.keys"
}

locals {
  lan_network         = "192.168.1.0/24"
  lan_network_gateway = cidrhost(local.lan_network, 1)
  iot_network         = "192.168.30.0/24"
  iot_network_gateway = cidrhost(local.iot_network, 1)
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

  nameserver = local.svc_network_gateway

  network_interfaces = [
    {
      network = local.svc_network
      address = cidrhost(local.svc_network, count.index + 10)
      gateway = local.svc_network_gateway
      tag     = 40
    }
  ]

  vm_settings = {
    automatic_reboot = false
    cores            = count.index < 2 ? 4 : 6 # pve-2 has more cores
    disk_size        = "400G"
    memory           = 24576 # 24G
    sockets          = 1
    start_on_boot    = true
    user             = "k3s"
  }
  vm_template = "ubuntu-cloud-init"
}

module "sandbox" {
  source = "./modules/vm"

  authorized_keys = data.http.github_keys.response_body
  name            = "sandbox"
  target_node     = "pve-2"

  nameserver = local.svc_network_gateway

  network_interfaces = [
    {
      network = local.svc_network
      address = cidrhost(local.svc_network, 60)
      gateway = local.svc_network_gateway
      tag     = 40
    },
    {
      network = local.iot_network
      address = cidrhost(local.iot_network, 60)
      tag     = 30
    },
  ]

  vm_settings = {
    automatic_reboot = true
    cores            = 1
    disk_size        = "20G"
    memory           = 2048 # 2G
    sockets          = 1
    start_on_boot    = false
    user             = "mohmann"
  }
  vm_template = "ubuntu-cloud-init"
}
