output "bucket_credentials" {
  sensitive = true
  value = {
    for bucket in module.bucket : (bucket.bucket_name) => {
      access_key_id     = bucket.user_name
      secret_access_key = bucket.secret_access_key
    }
  }
}
