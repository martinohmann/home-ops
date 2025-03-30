data "http" "github_keys" {
  url = "https://github.com/martinohmann.keys"
}

locals {
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
    cores            = count.index < 2 ? 4 : 6 # pve-2 has more cores
    disk_size        = "400G"
    memory           = 24576 # 24G
    network_tag      = 40
    sockets          = 1
    start_on_boot    = true
    user             = "k3s"
  }
  vm_template = "ubuntu-cloud-init"
}
