module "secrets" {
  source = "../modules/sops-secrets"
  file   = "../secrets.sops.yaml"
  key    = "minio"
}

provider "minio" {
  minio_server   = "s3.18b.haus:443"
  minio_user     = module.secrets.data.user
  minio_password = module.secrets.data.password
  minio_ssl      = true
}
