output "bucket_name" {
  value = minio_s3_bucket.bucket.bucket
}

output "secret_access_key" {
  sensitive = true
  value     = minio_iam_user.user.secret
}

output "user_name" {
  value = minio_iam_user.user.name
}
