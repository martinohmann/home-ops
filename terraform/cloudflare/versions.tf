terraform {
  backend "kubernetes" {
    config_context = "storage"
    namespace      = "terraform"
    secret_suffix  = "cloudflare"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.7.1"
    }
  }
}
