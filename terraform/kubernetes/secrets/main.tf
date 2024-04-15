variable "context" {
  default     = null
  description = "Kubeconfig context to use"
  type        = string
}

variable "secrets" {
  default     = {}
  description = "Map of arbitrary names to Kubernetes secret references"
  type = map(object({
    namespace = string
    name      = string
  }))
}

provider "kubernetes" {
  config_context = var.context
}

data "kubernetes_secret" "all" {
  for_each = var.secrets

  metadata {
    name      = each.value.name
    namespace = each.value.namespace
  }
}

output "data" {
  description = "Map of names uses as keys in the `secrets` variable to the referenced secret's data"
  value       = { for name, secret in data.kubernetes_secret.all : name => secret.data }
}
