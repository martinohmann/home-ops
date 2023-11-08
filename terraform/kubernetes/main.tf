module "kubernetes" {
  source = "../modules/k3s-nodes"

  authorized_keys_file = "authorized_keys"

  proxmox_nodes = ["pve01"]
  node_template = "ubuntu-2204-cloudinit-template"

  network_gateway = "192.168.178.1"
  lan_subnet      = "192.168.178.0/24"

  # 192.168.178.216 -> 192.168.178.223 (6 available IPs for nodes)
  control_plane_subnet = "192.168.178.216/29"

  # 192.168.178.224 -> 192.168.178.239 (14 available IPs for nodes)
  worker_node_subnet = "192.168.178.224/28"

  master_node_count = 3
  master_node_settings = {
    cores  = 2
    memory = 3072
  }

  worker_node_count = 3
  worker_node_settings = {
    cores     = 2
    disk_size = "50G"
    memory    = 6144
  }
}
