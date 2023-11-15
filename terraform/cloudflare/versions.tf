terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.19.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }

  required_version = ">= 1.3.0"
}
