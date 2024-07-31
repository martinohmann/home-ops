terraform {
  backend "kubernetes" {
    config_context = "storage"
    namespace      = "terraform"
    secret_suffix  = "minio"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    minio = {
      source  = "aminueza/minio"
      version = "2.4.2"
    }
  }
}
