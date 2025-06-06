variable "authorized_keys" {
  description = "Authorized keys to upload to the VM. Will be placed in ~/.ssh/authorized_keys of the VM user."
  type        = string
}

variable "name" {
  default     = null
  description = "The name to use for the VM."
  type        = string
}

variable "nameserver" {
  default     = null
  description = "The nameserver to assign to VM."
  type        = string
}

variable "network_settings" {
  description = "Settings for the VM's network devices"
  type = list(object({
    address  = string
    network  = string
    gateway  = string
    firewall = optional(bool, true)
    bridge   = optional(string, "vmbr0")
    tag      = optional(number, -1)
  }))

  validation {
    condition     = length(var.network_settings) > 0
    error_message = "There must be at least one network_settings configuration."
  }

  validation {
    condition     = length(var.network_settings) <= 4
    error_message = "There can be maximum four network_settings configuration."
  }
}

variable "target_node" {
  description = "Proxmox node to create the VM on."
  type        = string
}

variable "vm_settings" {
  description = "The settings for the VM."
  type = object({
    automatic_reboot = optional(bool, true)
    cores            = optional(number, 2)
    disk_size        = optional(string, "10G")
    memory           = optional(number, 4096)
    sockets          = optional(number, 1)
    start_on_boot    = optional(bool, false)
    storage_id       = optional(string, "local-lvm")
    user             = optional(string, "user")
  })
}

variable "vm_template" {
  description = "Proxmox VM to use as a base template for the VM. Can be a template or another VM that supports cloud-init."
  type        = string
}
