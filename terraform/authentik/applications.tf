data "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }
}

module "oauth2-grafana" {
  source             = "./modules/oauth2-application"
  name               = "Grafana"
  icon_url           = "https://raw.githubusercontent.com/grafana/grafana/main/public/img/icons/mono/grafana.svg"
  launch_url         = "https://grafana.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "grafana"
  client_secret      = data.kubernetes_secret.grafana.data["GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET"]
  redirect_uris      = ["https://grafana.18b.haus/login/generic_oauth"]
}

data "kubernetes_secret" "kube-web-view" {
  metadata {
    name      = "kube-web-view"
    namespace = "monitoring"
  }
}

module "oauth2-kube-web-view" {
  source             = "./modules/oauth2-application"
  name               = "Kube Web View"
  slug               = "kube-web-view"
  icon_url           = "https://codeberg.org/repo-avatars/1013-79c19f23d3617c23ec9f668a3c5fe0c5"
  launch_url         = "https://kube-web-view.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "kube-web-view"
  client_secret      = data.kubernetes_secret.kube-web-view.data["OAUTH2_CLIENT_SECRET"]
  redirect_uris      = ["https://kube-web-view.18b.haus/oauth2/callback"]
}

data "kubernetes_secret" "gitops" {
  metadata {
    name      = "oidc-auth"
    namespace = "flux-system"
  }
}

module "oauth2-gitops" {
  source             = "./modules/oauth2-application"
  name               = "GitOps"
  icon_url           = "https://raw.githubusercontent.com/weaveworks/weave-gitops/main/ui/images/logoLight.svg"
  launch_url         = "https://gitops.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "gitops"
  client_secret      = data.kubernetes_secret.gitops.data["clientSecret"]
  redirect_uris      = ["https://gitops.18b.haus/oauth2/callback"]
}

data "kubernetes_secret" "minio" {
  metadata {
    name      = "minio"
    namespace = "default"
  }
}

module "oauth2-minio" {
  source             = "./modules/oauth2-application"
  name               = "MinIO"
  icon_url           = "https://raw.githubusercontent.com/minio/minio/master/.github/logo.svg"
  launch_url         = "https://minio.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "minio"
  client_secret      = data.kubernetes_secret.minio.data["MINIO_IDENTITY_OPENID_CLIENT_SECRET"]
  redirect_uris      = ["https://minio.18b.haus/oauth_callback"]
}
