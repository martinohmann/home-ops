module "main-secrets" {
  source = "../kubernetes/secrets"

  context = "main"

  secrets = {
    cloudnative-pg  = { namespace = "database", name = "cloudnative-pg" }
    cluster-secrets = { namespace = "flux-system", name = "cluster-secrets" }
    forgejo         = { namespace = "default", name = "forgejo-secret" }
    netbox          = { namespace = "default", name = "netbox" }
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
    cloudnative-pg       = module.main-secrets.data.cloudnative-pg["aws-secret-access-key"]
    forgejo              = module.main-secrets.data.forgejo["minio-secret-access-key"]
    netbox               = module.main-secrets.data.netbox["minio-secret-access-key"]
    terraform-state-sync = module.storage-secrets.data.terraform-state-sync["MINIO_SECRET_KEY"]
    thanos               = module.main-secrets.data.cluster-secrets["SECRET_THANOS_MINIO_SECRET_ACCESS_KEY"]
    volsync              = module.main-secrets.data.cluster-secrets["SECRET_VOLSYNC_MINIO_SECRET_ACCESS_KEY"]
  }
}

module "bucket" {
  for_each          = local.buckets
  source            = "./modules/bucket"
  bucket_name       = each.key
  secret_access_key = each.value
}
