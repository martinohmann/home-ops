variable "authorized_keys_file" {
  description = "Path to file containing public SSH keys for remoting into nodes."
  type        = string
}

variable "cluster_name" {
  default     = "k3s"
  type        = string
  description = "Name of the cluster used for prefixing cluster components (ie nodes)."
}

variable "control_plane_subnet" {
  description = "Subnet for master nodes."
  type        = string
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.control_plane_subnet))
    error_message = "The control_plane_subnet value must be a valid cidr range."
  }
}

variable "lan_subnet" {
  description = <<EOF
Subnet used by the LAN network. Note that only the bit count number at the end
is acutally used, and all other subnets provided are secondary subnets.
EOF
  type        = string

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.lan_subnet))
    error_message = "The lan_subnet value must be a valid cidr range."
  }
}

variable "master_node_count" {
  description = "Number of master nodes."
  default     = 2
  type        = number
}

variable "master_node_settings" {
  type = object({
    cicustom       = optional(string),
    cores          = optional(number, 2),
    disk_size      = optional(string, "32G"),
    memory         = optional(number, 4096),
    network_bridge = optional(string, "vmbr0"),
    network_tag    = optional(number, -1),
    sockets        = optional(number, 1),
    storage_id     = optional(string, "local-lvm"),
    template       = optional(string),
    user           = optional(string, "k3s"),
  })
}

variable "nameserver" {
  default     = ""
  type        = string
  description = "nameserver"
}

variable "network_gateway" {
  description = "IP address of the network gateway."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_gateway))
    error_message = "The network_gateway value must be a valid ip."
  }
}

variable "node_template" {
  type        = string
  description = <<EOF
Proxmox vm to use as a base template for all nodes. Can be a template or
another vm that supports cloud-init.
EOF
}

variable "proxmox_nodes" {
  description = "Proxmox nodes to create VMs on. The VMs are spread across these nodes evenly."
  type        = list(string)

  validation {
    condition     = length(var.proxmox_nodes) > 0
    error_message = "There must be at least one proxmox node configured."
  }
}

variable "worker_node_count" {
  description = "Number of worker nodes."
  default     = 2
  type        = number
}

variable "worker_node_settings" {
  type = object({
    cicustom       = optional(string),
    cores          = optional(number, 2),
    disk_size      = optional(string, "32G"),
    memory         = optional(number, 4096),
    network_bridge = optional(string, "vmbr0"),
    network_tag    = optional(number, -1),
    sockets        = optional(number, 1),
    storage_id     = optional(string, "local-lvm"),
    template       = optional(string),
    user           = optional(string, "k3s"),
  })
}

variable "worker_node_subnet" {
  description = "Subnet for worker nodes."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2}$", var.worker_node_subnet))
    error_message = "The worker_node_subnet value must be a valid cidr range."
  }
}
