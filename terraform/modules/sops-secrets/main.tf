data "sops_file" "secrets" {
  source_file = var.file
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
  data    = local.secrets[var.key]
}
