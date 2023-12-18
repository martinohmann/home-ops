module "buckets" {
  source = "../modules/sops-secrets"
  file   = "../secrets.sops.yaml"
  key    = "minio_buckets"
}

module "bucket" {
  for_each          = nonsensitive(module.buckets.data)
  source            = "../modules/minio-bucket"
  bucket_name       = each.key
  secret_access_key = each.value.secret_access_key
}
