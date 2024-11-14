module "secrets" {
  source = "../kubernetes/secrets"

  secrets = {
    forgejo       = { path = "main/apps/default/forgejo/app/secret.sops.yaml", name = "forgejo-oauth-secret" }
    grafana       = { path = "main/apps/monitoring/grafana/app/secret.sops.yaml", name = "grafana-secret" }
    kopia-b2      = { path = "storage/apps/default/kopia/b2/secret.sops.yaml", name = "kopia-b2-secret" }
    kopia-local   = { path = "storage/apps/default/kopia/local/secret.sops.yaml", name = "kopia-local-secret" }
    kube-web-view = { path = "main/apps/monitoring/kube-web-view/app/secret.sops.yaml", name = "kube-web-view" }
    miniflux      = { path = "main/apps/default/miniflux/app/secret.sops.yaml", name = "miniflux" }
    minio         = { path = "storage/apps/default/minio/app/secret.sops.yaml", name = "minio" }
    nextcloud     = { path = "main/apps/default/nextcloud/app/secret.sops.yaml", name = "nextcloud-secret" }
    pgadmin       = { path = "main/apps/database/pgadmin/app/secret.sops.yaml", name = "pgadmin" }
  }
}

data "sops_file" "secrets" {
  source_file = "secrets.sops.yaml"
}
