terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.1"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}
