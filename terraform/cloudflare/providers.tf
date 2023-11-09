data "sops_file" "secrets" {
  source_file = "../secrets.sops.yaml"
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
  domain  = local.secrets.cloudflare.domain
}

provider "cloudflare" {
  email   = local.secrets.cloudflare.email
  api_key = local.secrets.cloudflare.api_key
}
