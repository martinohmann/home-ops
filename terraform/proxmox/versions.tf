terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}
