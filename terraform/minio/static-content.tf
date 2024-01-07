resource "minio_s3_bucket" "static-content" {
  bucket = "static-content"
  acl    = "public"
}
