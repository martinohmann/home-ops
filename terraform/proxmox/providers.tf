module "secrets" {
  source = "../modules/sops-secrets"
  file   = "../secrets.sops.yaml"
  key    = "proxmox"
}

provider "proxmox" {
  pm_api_url  = "https://pve.18b.lan:8006/api2/json"
  pm_user     = module.secrets.data.user
  pm_password = module.secrets.data.password
}
