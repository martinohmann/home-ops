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
  client_secret      = module.secrets-main.data.grafana["GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET"]
  redirect_uris      = ["https://grafana.18b.haus/login/generic_oauth"]
}

module "oauth2-minio" {
  source                       = "./modules/oauth2-application"
  name                         = "MinIO"
  icon_url                     = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/minio.svg"
  launch_url                   = "https://minio.18b.haus"
  newtab                       = true
  auth_groups                  = [authentik_group.infra.id, authentik_group.admins.id]
  authorization_flow           = data.authentik_flow.default-authorization-flow.id
  client_id                    = "minio"
  client_secret                = module.secrets-storage.data.minio["MINIO_IDENTITY_OPENID_CLIENT_SECRET"]
  redirect_uris                = ["https://minio.18b.haus/oauth_callback"]
  additional_property_mappings = [authentik_property_mapping_provider_scope.openid-minio.id]
}

module "oauth2-nextcloud" {
  source                       = "./modules/oauth2-application"
  name                         = "Nextcloud"
  icon_url                     = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/nextcloud.svg"
  launch_url                   = "https://cloud.18b.haus"
  newtab                       = true
  auth_groups                  = [authentik_group.nextcloud.id, authentik_group.admins.id]
  authorization_flow           = data.authentik_flow.default-authorization-flow.id
  client_id                    = "nextcloud"
  client_secret                = module.secrets-main.data.nextcloud["OIDC_CLIENT_SECRET"]
  redirect_uris                = ["https://cloud.18b.haus/apps/oidc_login/oidc"]
  additional_property_mappings = [authentik_property_mapping_provider_scope.openid-nextcloud.id]
}

module "oauth2-proxmox" {
  source             = "./modules/oauth2-application"
  name               = "Proxmox VE"
  slug               = "proxmox"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/proxmox.svg"
  launch_url         = "https://pve.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.infra.id, authentik_group.admins.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "proxmox"
  redirect_uris = [
    "https://pve.18b.haus",
    "https://pve.18b.lan:8006",
    "https://pve-0.18b.lan:8006",
    "https://pve-1.18b.lan:8006",
    "https://pve-2.18b.lan:8006"
  ]
}

module "oauth2-pgadmin" {
  source             = "./modules/oauth2-application"
  name               = "pgAdmin"
  icon_url           = "https://wiki.postgresql.org/images/a/a4/PostgreSQL_logo.3colors.svg"
  launch_url         = "https://pgadmin.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.infra.id, authentik_group.admins.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "pgadmin"
  client_secret      = module.secrets-main.data.pgadmin["OAUTH2_CLIENT_SECRET"]
  redirect_uris      = ["https://pgadmin.18b.haus/oauth2/authorize"]
}

module "oauth2-forgejo" {
  source             = "./modules/oauth2-application"
  name               = "Forgejo"
  slug               = "forgejo"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/forgejo.svg"
  launch_url         = "https://forgejo.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id, authentik_group.admins.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "forgejo"
  client_secret      = module.secrets-main.data.forgejo["secret"]
  redirect_uris      = ["https://git.18b.haus/user/oauth2/Authentik/callback"]
}

module "oauth2-miniflux" {
  source             = "./modules/oauth2-application"
  name               = "Miniflux"
  slug               = "miniflux"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/miniflux.svg"
  launch_url         = "https://miniflux.18b.haus"
  newtab             = true
  auth_groups        = [authentik_group.users.id, authentik_group.admins.id]
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_id          = "miniflux"
  client_secret      = module.secrets-main.data.miniflux["OAUTH2_CLIENT_SECRET"]
  redirect_uris      = ["https://miniflux.18b.haus/oauth2/oidc/callback"]
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
  client_secret      = module.secrets-main.data.kube-web-view["OAUTH2_CLIENT_SECRET"]
  redirect_uris      = ["https://kube-web-view.18b.haus/oauth2/callback"]
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

module "proxy-home-assistant-code" {
  source             = "./modules/proxy-application"
  name               = "Home Assistant Code"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/vscode.svg"
  slug               = "home-assistant-code"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-redis-commander" {
  source             = "./modules/proxy-application"
  name               = "Redis Commander"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/redis.svg"
  slug               = "redis"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-zigbee2mqtt" {
  source             = "./modules/proxy-application"
  name               = "Zigbee2MQTT"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/zigbee2mqtt.svg"
  slug               = "zigbee"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-filebrowser" {
  source             = "./modules/proxy-application"
  name               = "Filebrowser"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/filebrowser.svg"
  slug               = "filebrowser"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

module "proxy-kopia" {
  source             = "./modules/proxy-application"
  name               = "Kopia"
  icon_url           = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/kopia.svg"
  slug               = "kopia"
  domain             = "18b.haus"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  auth_groups        = [authentik_group.admins.id]
}

resource "authentik_outpost" "main-proxy" {
  name = "main-proxy"
  type = "proxy"

  service_connection = authentik_service_connection_kubernetes.main.id

  protocol_providers = [
    module.proxy-longhorn.id,
    module.proxy-home-assistant-code.id,
    module.proxy-redis-commander.id,
    module.proxy-zigbee2mqtt.id,
  ]

  config = jsonencode({
    authentik_host          = "https://identity.18b.haus",
    authentik_host_insecure = false,
    authentik_host_browser  = "",
    log_level               = "debug",
    object_naming_template  = "authentik-outpost-proxy",
    docker_network          = null,
    docker_map_ports        = true,
    docker_labels           = null,
    container_image         = null,
    kubernetes_replicas     = 1,
    kubernetes_namespace    = "identity",
    kubernetes_ingress_annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    },
    kubernetes_ingress_secret_name = "authentik-outpost-proxy-tls",
    kubernetes_service_type        = "ClusterIP",
    kubernetes_disabled_components = [],
    kubernetes_image_pull_secrets  = []
  })
}

resource "authentik_outpost" "storage-proxy" {
  name = "storage-proxy"
  type = "proxy"

  service_connection = authentik_service_connection_kubernetes.storage.id

  protocol_providers = [
    module.proxy-filebrowser.id,
    module.proxy-kopia.id,
  ]

  config = jsonencode({
    authentik_host          = "https://identity.18b.haus",
    authentik_host_insecure = false,
    authentik_host_browser  = "",
    log_level               = "debug",
    object_naming_template  = "authentik-outpost-proxy",
    docker_network          = null,
    docker_map_ports        = true,
    docker_labels           = null,
    container_image         = null,
    kubernetes_replicas     = 1,
    kubernetes_namespace    = "identity",
    kubernetes_ingress_annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    },
    kubernetes_ingress_secret_name = "authentik-outpost-proxy-tls",
    kubernetes_service_type        = "ClusterIP",
    kubernetes_disabled_components = [],
    kubernetes_image_pull_secrets  = []
  })
}
