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

variable "network_interfaces" {
  description = "Configuration of the VM's network interfaces."
  type = list(object({
    address  = string
    network  = string
    gateway  = string
    firewall = optional(bool, true)
    bridge   = optional(string, "vmbr0")
    tag      = optional(number, -1)
  }))

  validation {
    condition = alltrue([
      for interface in var.network_interfaces :
      can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", interface.network))
    ])
    error_message = "The network_interfaces.network value must be a valid IPv4 CIDR range."
  }

  validation {
    condition = alltrue([
      for interface in var.network_interfaces :
      can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", interface.address))
    ])
    error_message = "The network_interfaces.address value must be a valid IPv4 address."
  }

  validation {
    condition = alltrue([
      for interface in var.network_interfaces :
      can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", interface.gateway))
    ])
    error_message = "The network_interfaces.gateway value must be a valid IPv4 address."
  }

  validation {
    condition     = length(var.network_interfaces) > 0
    error_message = "There must be at least one configuration in network_interfaces."
  }

  validation {
    condition     = length(var.network_interfaces) <= 4
    error_message = "There can be at maximum four configurations in network_interfaces."
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
