terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2023.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}
