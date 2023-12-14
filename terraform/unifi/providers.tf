data "sops_file" "secrets" {
  source_file = "../secrets.sops.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw).unifi
}

provider "unifi" {
  username       = local.secrets.username
  password       = local.secrets.password
  api_url        = "https://unifi.18b.lan:8443"
  allow_insecure = true
}
