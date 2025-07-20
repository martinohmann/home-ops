terraform {
  backend "kubernetes" {
    config_context = "storage"
    namespace      = "terraform"
    secret_suffix  = "minio"
  }

  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "3.6.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
}
