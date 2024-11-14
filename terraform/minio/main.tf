module "secrets" {
  source = "../kubernetes/secrets"

  secrets = {
    cloudnative-pg       = { path = "main/apps/database/cloudnative-pg/app/secret.sops.yaml", name = "cloudnative-pg" }
    cluster-secrets      = { path = "main/flux/vars/cluster-secrets.sops.yaml", name = "cluster-secrets" }
    forgejo              = { path = "main/apps/default/forgejo/app/secret.sops.yaml", name = "forgejo-secret" }
    terraform-state-sync = { path = "storage/apps/terraform/terraform-state-sync/app/secret.sops.yaml", name = "terraform-state-sync" }
  }
}

locals {
  buckets = {
    cloudnative-pg       = module.secrets.data.cloudnative-pg["aws-secret-access-key"]
    forgejo              = module.secrets.data.forgejo["minio-secret-access-key"]
    terraform-state-sync = module.secrets.data.terraform-state-sync["MINIO_SECRET_KEY"]
    thanos               = module.secrets.data.cluster-secrets["SECRET_THANOS_MINIO_SECRET_ACCESS_KEY"]
    volsync              = module.secrets.data.cluster-secrets["SECRET_VOLSYNC_MINIO_SECRET_ACCESS_KEY"]
  }
}

module "bucket" {
  for_each          = local.buckets
  source            = "./modules/bucket"
  bucket_name       = each.key
  secret_access_key = each.value
}
