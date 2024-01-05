data "authentik_tenant" "authentik-default" {
  domain = "authentik-default"
}

resource "authentik_tenant" "home" {
  domain           = "18b.haus"
  default          = false
  branding_title   = "identity.18b.haus"
  branding_logo    = data.authentik_tenant.authentik-default.branding_logo
  branding_favicon = data.authentik_tenant.authentik-default.branding_favicon
  event_retention  = "days=365"
}
