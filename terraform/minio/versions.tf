terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    minio = {
      source  = "aminueza/minio"
      version = "2.0.1"
    }
  }
}
