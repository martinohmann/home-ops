terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.20.0"
    }
  }

  required_version = ">= 1.3.0"
}
