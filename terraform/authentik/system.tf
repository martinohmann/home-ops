data "authentik_brand" "authentik-default" {
  domain = "authentik-default"
}

resource "authentik_brand" "home" {
  domain              = "18b.haus"
  default             = false
  branding_title      = "identity.18b.haus"
  branding_logo       = data.authentik_brand.authentik-default.branding_logo
  branding_favicon    = data.authentik_brand.authentik-default.branding_favicon
  flow_authentication = data.authentik_flow.default-authentication-flow.id
  flow_invalidation   = data.authentik_flow.default-invalidation-flow.id
  flow_user_settings  = data.authentik_flow.default-user-settings-flow.id
}

resource "authentik_service_connection_kubernetes" "local" {
  name  = "local"
  local = true
}
