locals {
  outpost_config = jsonencode({
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

resource "authentik_outpost" "main-proxy" {
  name               = "main-proxy"
  type               = "proxy"
  config             = local.outpost_config
  service_connection = authentik_service_connection_kubernetes.main.id

  protocol_providers = [
    module.proxy-esphome-code.id,
    module.proxy-home-assistant-code.id,
    module.proxy-longhorn.id,
    module.proxy-redis-commander.id,
    module.proxy-zigbee2mqtt.id,
  ]
}

resource "authentik_outpost" "storage-proxy" {
  name               = "storage-proxy"
  type               = "proxy"
  config             = local.outpost_config
  service_connection = authentik_service_connection_kubernetes.storage.id

  protocol_providers = [
    module.proxy-backrest.id,
    module.proxy-filebrowser.id,
    module.proxy-kopia-b2.id,
    module.proxy-kopia-local.id,
  ]
}
