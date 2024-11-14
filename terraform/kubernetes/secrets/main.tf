variable "secrets" {
  default     = {}
  description = "Map of arbitrary names to file objects"
  type = map(object({
    name = string
    path = string
  }))
}

data "sops_file" "secrets" {
  for_each    = var.secrets
  source_file = "${path.module}/../../../kubernetes/${each.value.path}"
}

output "data" {
  description = "Map of names uses as keys in the `secrets` variable to the referenced secret's data"
  sensitive   = true

  # This handles multi-document YAML files and selects the data of the
  # Kubernetes secret with the matching name for each requested secret file.
  value = {
    for name, secret in var.secrets :
    name => one([
      for data in [
        # yamldecode does not support multi-document YAML files, so we're doing
        # the splitting ourselves.
        for document in compact(split("---", data.sops_file.secrets[name].raw)) :
        yamldecode(document)
      ] :
      data.stringData
      if data.apiVersion == "v1" && data.kind == "Secret" && data.metadata.name == secret.name
    ])
  }
}
