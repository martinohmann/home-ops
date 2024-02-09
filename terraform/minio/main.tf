data "kubernetes_secret" "argo-workflows" {
  metadata {
    name      = "argo-minio-credentials"
    namespace = "argo"
  }
}

data "kubernetes_secret" "cloudnative-pg" {
  metadata {
    name      = "cloudnative-pg"
    namespace = "database"
  }
}

data "kubernetes_secret" "cluster-secrets" {
  metadata {
    name      = "cluster-secrets"
    namespace = "flux-system"
  }
}

data "kubernetes_secret" "gitea" {
  metadata {
    name      = "gitea-secret"
    namespace = "default"
  }
}

locals {
  buckets = {
    argo-workflow-artifacts = data.kubernetes_secret.argo-workflows.data["secret-access-key"]
    cloudnative-pg          = data.kubernetes_secret.cloudnative-pg.data["aws-secret-access-key"]
    gitea                   = data.kubernetes_secret.gitea-pg.data["minio-secret-access-key"]
    volsync                 = data.kubernetes_secret.cluster-secrets.data["SECRET_VOLSYNC_MINIO_SECRET_ACCESS_KEY"]
  }
}

module "bucket" {
  for_each          = local.buckets
  source            = "./modules/bucket"
  bucket_name       = each.key
  secret_access_key = each.value
}
