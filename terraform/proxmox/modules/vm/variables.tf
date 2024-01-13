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

variable "network" {
  description = "Subnet in which to create the VM."
  type        = string
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.network))
    error_message = "The network value must be a valid IPv4 CIDR range."
  }
}

variable "network_address" {
  description = "IP address to assign to the VM."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_address))
    error_message = "The network_gateway value must be a valid IPv4 address."
  }
}

variable "network_gateway" {
  description = "IP address of the network gateway."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_gateway))
    error_message = "The network_gateway value must be a valid IPv4 address."
  }
}

variable "target_node" {
  description = "Proxmox node to create the VM on."
  type        = string
}

variable "vm_settings" {
  description = "The settings for the VM."
  type = object({
    cores          = optional(number, 2)
    disk_size      = optional(string, "10G")
    firewall       = optional(bool, true)
    memory         = optional(number, 4096)
    network_bridge = optional(string, "vmbr0")
    network_tag    = optional(number, -1)
    sockets        = optional(number, 1)
    start_on_boot  = optional(bool, false)
    storage_id     = optional(string, "local-lvm")
    user           = optional(string, "user")
  })
}

variable "vm_template" {
  description = "Proxmox VM to use as a base template for the VM. Can be a template or another VM that supports cloud-init."
  type        = string
}
