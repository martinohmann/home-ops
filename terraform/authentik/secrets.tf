module "secrets" {
  source = "../kubernetes/secrets"

  secrets = {
    forgejo        = { path = "main/apps/default/forgejo/app/secret.sops.yaml", name = "forgejo-oauth-secret" }
    gitops-main    = { path = "main/apps/flux-system/weave-gitops/app/secret.sops.yaml", name = "weave-gitops-oidc-auth" }
    gitops-storage = { path = "storage/apps/flux-system/weave-gitops/app/secret.sops.yaml", name = "weave-gitops-oidc-auth" }
    grafana        = { path = "main/apps/monitoring/grafana/app/secret.sops.yaml", name = "grafana-secret" }
    kube-web-view  = { path = "main/apps/monitoring/kube-web-view/app/secret.sops.yaml", name = "kube-web-view" }
    miniflux       = { path = "main/apps/default/miniflux/app/secret.sops.yaml", name = "miniflux" }
    minio          = { path = "storage/apps/default/minio/app/secret.sops.yaml", name = "minio" }
    nextcloud      = { path = "main/apps/default/nextcloud/app/secret.sops.yaml", name = "nextcloud-secret" }
    pgadmin        = { path = "main/apps/database/pgadmin/app/secret.sops.yaml", name = "pgadmin" }
  }
}

data "sops_file" "secrets" {
  source_file = "secrets.sops.yaml"
}
