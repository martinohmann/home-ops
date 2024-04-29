data "authentik_brand" "authentik-default" {
  domain = "authentik-default"
}

resource "authentik_brand" "home" {
  domain              = "18b.haus"
  default             = false
  branding_title      = "identity.18b.haus"
  branding_logo       = data.authentik_brand.authentik-default.branding_logo
  branding_favicon    = data.authentik_brand.authentik-default.branding_favicon
  flow_authentication = authentik_flow.authentication-flow.uuid
  flow_invalidation   = data.authentik_flow.default-invalidation-flow.id
  flow_user_settings  = data.authentik_flow.default-user-settings-flow.id
}

resource "authentik_service_connection_kubernetes" "main" {
  name  = "main"
  local = true
}

data "sops_file" "secrets" {
  source_file = "secrets.sops.yaml"
}

resource "authentik_service_connection_kubernetes" "storage" {
  name       = "storage"
  kubeconfig = jsonencode(yamldecode(data.sops_file.secrets.data["kubeconfig.storage.yaml"]))
}
