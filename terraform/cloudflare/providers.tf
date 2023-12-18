module "secrets" {
  source = "../modules/sops-secrets"
  file   = "../secrets.sops.yaml"
  key    = "cloudflare"
}

provider "cloudflare" {
  email   = module.secrets.data.email
  api_key = module.secrets.data.api_key
}
