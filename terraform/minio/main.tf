module "secrets" {
  source = "../kubernetes/secrets"

  context = "main"

  secrets = {
    argo-workflows  = { namespace = "argo", name = "argo-minio-credentials" }
    cloudnative-pg  = { namespace = "database", name = "cloudnative-pg" }
    cluster-secrets = { namespace = "flux-system", name = "cluster-secrets" }
    gitea           = { namespace = "default", name = "gitea-secret" }
  }
}

locals {
  buckets = {
    argo-workflow-artifacts = module.secrets.data.argo-workflows["secret-access-key"]
    cloudnative-pg          = module.secrets.data.cloudnative-pg["aws-secret-access-key"]
    gitea                   = module.secrets.data.gitea["minio-secret-access-key"]
    thanos                  = module.secrets.data.cluster-secrets["SECRET_THANOS_MINIO_SECRET_ACCESS_KEY"]
    volsync                 = module.secrets.data.cluster-secrets["SECRET_VOLSYNC_MINIO_SECRET_ACCESS_KEY"]
  }
}

module "bucket" {
  for_each          = local.buckets
  source            = "./modules/bucket"
  bucket_name       = each.key
  secret_access_key = each.value
}
