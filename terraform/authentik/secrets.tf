module "secrets-main" {
  source = "../kubernetes/secrets"

  cluster = "main"

  secrets = {
    forgejo       = { path = "apps/default/forgejo/app/secret.sops.yaml", name = "forgejo-oauth-secret" }
    grafana       = { path = "apps/monitoring/grafana/app/secret.sops.yaml", name = "grafana-secret" }
    kube-web-view = { path = "apps/monitoring/kube-web-view/app/secret.sops.yaml", name = "kube-web-view" }
    miniflux      = { path = "apps/default/miniflux/app/secret.sops.yaml", name = "miniflux" }
    nextcloud     = { path = "apps/default/nextcloud/app/secret.sops.yaml", name = "nextcloud-secret" }
    pgadmin       = { path = "apps/database/pgadmin/app/secret.sops.yaml", name = "pgadmin" }
  }
}

module "secrets-storage" {
  source = "../kubernetes/secrets"

  cluster = "storage"

  secrets = {
    minio = { path = "apps/default/minio/app/secret.sops.yaml", name = "minio" }
    kopia = { path = "apps/default/kopia/local/secret.sops.yaml", name = "kopia-local-secret" }
  }
}

data "sops_file" "secrets" {
  source_file = "secrets.sops.yaml"
}
