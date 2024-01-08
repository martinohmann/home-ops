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
  auth_groups        = [authentik_group.infra.id, authentik_group.admins.id]
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
  auth_groups        = [authentik_group.infra.id, authentik_group.admins.id]
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
  auth_groups        = [authentik_group.infra.id, authentik_group.admins.id]
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
  source                       = "./modules/oauth2-application"
  name                         = "MinIO"
  icon_url                     = "https://raw.githubusercontent.com/minio/minio/master/.github/logo.svg"
  launch_url                   = "https://minio.18b.haus"
  newtab                       = true
  auth_groups                  = [authentik_group.infra.id, authentik_group.admins.id]
  authorization_flow           = data.authentik_flow.default-authorization-flow.id
  client_id                    = "minio"
  client_secret                = data.kubernetes_secret.minio.data["MINIO_IDENTITY_OPENID_CLIENT_SECRET"]
  redirect_uris                = ["https://minio.18b.haus/oauth_callback"]
  additional_property_mappings = [authentik_scope_mapping.openid-minio.id]
}

data "kubernetes_secret" "nextcloud" {
  metadata {
    name      = "nextcloud-secret"
    namespace = "default"
  }
}

module "oauth2-nextcloud" {
  source                       = "./modules/oauth2-application"
  name                         = "Nextcloud"
  icon_url                     = "https://upload.wikimedia.org/wikipedia/commons/6/60/Nextcloud_Logo.svg"
  launch_url                   = "https://cloud.18b.haus"
  newtab                       = true
  auth_groups                  = [authentik_group.nextcloud.id, authentik_group.admins.id]
  authorization_flow           = data.authentik_flow.default-authorization-flow.id
  client_id                    = "nextcloud"
  client_secret                = data.kubernetes_secret.nextcloud.data["OIDC_CLIENT_SECRET"]
  redirect_uris                = ["https://cloud.18b.haus/apps/oidc_login/oidc"]
  additional_property_mappings = [authentik_scope_mapping.openid-nextcloud.id]
}

module "proxy-longhorn" {
  source             = "./modules/proxy-application"
  name               = "Longhorn"
  icon_url           = "https://raw.githubusercontent.com/longhorn/website/master/static/img/icon-longhorn.svg"
  slug               = "longhorn"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-kubernetes-dashboard" {
  source             = "./modules/proxy-application"
  name               = "Kubernetes Dashboard"
  icon_url           = "https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.svg"
  slug               = "kubernetes"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-home-assistant-code" {
  source             = "./modules/proxy-application"
  name               = "Home Assistant Code"
  slug               = "home-assistant-code"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

resource "authentik_outpost" "proxy" {
  name = "proxy"
  type = "proxy"

  service_connection = authentik_service_connection_kubernetes.local.id

  protocol_providers = [
    module.proxy-longhorn.id,
    module.proxy-kubernetes-dashboard.id,
    module.proxy-home-assistant-code.id,
  ]

  config = jsonencode({
    authentik_host          = "https://identity.18b.haus",
    authentik_host_insecure = false,
    authentik_host_browser  = "",
    log_level               = "debug",
    object_naming_template  = "authentik-outpost-%(name)s",
    docker_network          = null,
    docker_map_ports        = true,
    docker_labels           = null,
    container_image         = null,
    kubernetes_replicas     = 1,
    kubernetes_namespace    = "identity",
    kubernetes_ingress_annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
      "hajimari.io/enable"             = "false"
    },
    kubernetes_ingress_secret_name = "authentik-proxy-outpost-tls",
    kubernetes_service_type        = "ClusterIP",
    kubernetes_disabled_components = [],
    kubernetes_image_pull_secrets  = []
  })
}
