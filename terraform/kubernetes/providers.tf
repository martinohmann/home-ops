data "sops_file" "secrets" {
  source_file = "../secrets.sops.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

provider "proxmox" {
  pm_api_url  = "https://pve01:8006/api2/json"
  pm_user     = local.secrets.proxmox.user
  pm_password = local.secrets.proxmox.password
}
