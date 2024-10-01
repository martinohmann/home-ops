module "main-secrets" {
  source = "../kubernetes/secrets"

  cluster = "main"

  secrets = {
    cloudnative-pg  = { path = "apps/database/cloudnative-pg/app/secret.sops.yaml", name = "cloudnative-pg" }
    cluster-secrets = { path = "flux/vars/cluster-secrets.sops.yaml", name = "cluster-secrets" }
    forgejo         = { path = "apps/default/forgejo/app/secret.sops.yaml", name = "forgejo-secret" }
  }
}

module "storage-secrets" {
  source = "../kubernetes/secrets"

  cluster = "storage"

  secrets = {
    terraform-state-sync = { path = "apps/terraform/terraform-state-sync/app/secret.sops.yaml", name = "terraform-state-sync" }
  }
}

locals {
  buckets = {
    cloudnative-pg       = module.main-secrets.data.cloudnative-pg["aws-secret-access-key"]
    forgejo              = module.main-secrets.data.forgejo["minio-secret-access-key"]
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
