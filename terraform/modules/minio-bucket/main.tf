resource "minio_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  acl           = "private"
}

resource "minio_iam_user" "user" {
  name          = var.bucket_name
  secret        = var.secret_access_key
  force_destroy = true

  lifecycle {
    ignore_changes = [
      # Updating the secret will cause the deletion of the user and break the
      # provider. I'll require manual removal of the
      # `minio_iam_user_policy_attachment` and `minio_iam_user` resources from
      # the state in order to be able to recreate them with the new secret.
      secret,
    ]
  }
}

data "minio_iam_policy_document" "policy" {
  statement {
    sid    = "FullBucketAccess"
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${minio_s3_bucket.bucket.bucket}",
      "arn:aws:s3:::${minio_s3_bucket.bucket.bucket}/*"
    ]
  }
}

resource "minio_iam_policy" "policy" {
  name   = var.bucket_name
  policy = data.minio_iam_policy_document.policy.json
}

resource "minio_iam_user_policy_attachment" "policy_attachement" {
  user_name   = minio_iam_user.user.id
  policy_name = minio_iam_policy.policy.id
}
