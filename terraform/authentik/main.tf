data "kubernetes_secret" "cluster-secrets" {
  metadata {
    name      = "cluster-secrets"
    namespace = "flux-system"
  }
}

locals {
  secrets = data.kubernetes_secret.cluster-secrets.data
}
