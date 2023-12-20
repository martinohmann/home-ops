module "bucket" {
  for_each          = toset(["cloudnative-pg", "volsync"])
  source            = "./modules/bucket"
  bucket_name       = each.value
  secret_access_key = lookup(var.secret_access_keys, each.value)
}
