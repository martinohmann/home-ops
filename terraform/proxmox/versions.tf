terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "0.3.2"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}
