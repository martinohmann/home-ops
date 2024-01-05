data "authentik_tenant" "authentik-default" {
  domain = "authentik-default"
}

resource "authentik_tenant" "home" {
  domain              = "18b.haus"
  default             = false
  branding_title      = "identity.18b.haus"
  branding_logo       = data.authentik_tenant.authentik-default.branding_logo
  branding_favicon    = data.authentik_tenant.authentik-default.branding_favicon
  flow_authentication = data.authentik_flow.default-authentication-flow.id
  flow_invalidation   = data.authentik_flow.default-invalidation-flow.id
  flow_user_settings  = data.authentik_flow.default-user-settings-flow.id
  event_retention     = "days=365"
}
