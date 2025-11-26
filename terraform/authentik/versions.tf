terraform {
  backend "kubernetes" {
    config_context = "storage"
    namespace      = "terraform"
    secret_suffix  = "authentik"
  }

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.10.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}
