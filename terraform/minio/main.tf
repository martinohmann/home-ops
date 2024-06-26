module "main-secrets" {
  source = "../kubernetes/secrets"

  context = "main"

  secrets = {
    argo-workflows  = { namespace = "argo", name = "argo-minio-credentials" }
    cloudnative-pg  = { namespace = "database", name = "cloudnative-pg" }
    cluster-secrets = { namespace = "flux-system", name = "cluster-secrets" }
    gitea           = { namespace = "default", name = "gitea-secret" }
  }
}

module "storage-secrets" {
  source = "../kubernetes/secrets"

  context = "storage"

  secrets = {
    terraform-state-sync = { namespace = "terraform", name = "terraform-state-sync" }
  }
}

locals {
  buckets = {
    argo-workflow-artifacts = module.main-secrets.data.argo-workflows["secret-access-key"]
    cloudnative-pg          = module.main-secrets.data.cloudnative-pg["aws-secret-access-key"]
    gitea                   = module.main-secrets.data.gitea["minio-secret-access-key"]
    terraform-state-sync    = module.storage-secrets.data.terraform-state-sync["MINIO_SECRET_KEY"]
    thanos                  = module.main-secrets.data.cluster-secrets["SECRET_THANOS_MINIO_SECRET_ACCESS_KEY"]
    volsync                 = module.main-secrets.data.cluster-secrets["SECRET_VOLSYNC_MINIO_SECRET_ACCESS_KEY"]
  }
}

module "bucket" {
  for_each          = local.buckets
  source            = "./modules/bucket"
  bucket_name       = each.key
  secret_access_key = each.value
}
