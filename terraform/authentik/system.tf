data "authentik_brand" "authentik-default" {
  domain = "authentik-default"
}

resource "authentik_brand" "home" {
  domain              = "18b.haus"
  default             = false
  branding_title      = "identity.18b.haus"
  branding_logo       = data.authentik_brand.authentik-default.branding_logo
  branding_favicon    = data.authentik_brand.authentik-default.branding_favicon
  flow_authentication = authentik_flow.authentication.uuid
  flow_invalidation   = data.authentik_flow.default-invalidation.id
  flow_recovery       = authentik_flow.recovery.uuid
  flow_user_settings  = data.authentik_flow.default-user-settings.id
}

resource "authentik_service_connection_kubernetes" "main" {
  name  = "main"
  local = true
}

resource "authentik_service_connection_kubernetes" "storage" {
  name       = "storage"
  kubeconfig = jsonencode(yamldecode(data.sops_file.secrets.data["kubeconfig.storage.yaml"]))
}
