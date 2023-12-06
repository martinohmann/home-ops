variable "authorized_keys" {
  description = "Authorized keys to upload to the VMs. Will be placed in ~/.ssh/authorized_keys of the VM user."
  type        = string
}

variable "name" {
  default     = null
  description = "The name to use for the VM. If unset, the name is generated from name_prefix and VM index. Ignored if vm_count > 1."
  type        = string
}

variable "name_prefix" {
  default     = "vm-"
  description = "The prefix used to generate the VM names."
  type        = string
}

variable "nameserver" {
  default     = null
  description = "The nameserver to assign to VMs."
  type        = string
}

variable "network" {
  description = "Subnet in which to create the VMs."
  type        = string
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.network))
    error_message = "The network value must be a valid IPv4 CIDR range."
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

variable "network_hostnum_start" {
  description = "The host number within the subnet from where to start allocation IPv4 addresses for the VMs."
  type        = number
}

variable "target_nodes" {
  description = "Proxmox nodes to create VMs on. The VMs are spread across these nodes in sequential order."
  type        = list(string)

  validation {
    condition     = length(var.target_nodes) > 0
    error_message = "There must be at least one proxmox target node configured."
  }
}

variable "vm_count" {
  description = "Number of VMs to create."
  default     = 1
  type        = number
}

variable "vm_settings" {
  description = "The settings for the VMs."
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
  description = "Proxmox VM to use as a base template for all VMs. Can be a template or another VM that supports cloud-init."
  type        = string
}
