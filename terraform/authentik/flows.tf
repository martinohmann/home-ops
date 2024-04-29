data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-invalidation-flow" {
  slug = "default-invalidation-flow"
}

data "authentik_flow" "default-user-settings-flow" {
  slug = "default-user-settings-flow"
}

resource "authentik_flow" "authentication-flow" {
  name        = "Welcome to authentik!"
  title       = "Welcome to authentik!"
  slug        = "authentication-flow"
  designation = "authentication"
  background  = "/static/dist/assets/images/flow_background.jpg"
}

resource "authentik_flow_stage_binding" "authentication-identification" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-identification.id
  order  = 10
}

resource "authentik_flow_stage_binding" "authentication-password" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-password.id
  order  = 20
}

resource "authentik_flow_stage_binding" "authentication-mfa-validation" {
  target = authentik_flow.authentication-flow.uuid
  stage  = authentik_stage_authenticator_validate.authentication-mfa-validation.id
  order  = 30
}

resource "authentik_flow_stage_binding" "authentication-login" {
  target = authentik_flow.authentication-flow.uuid
  stage  = authentik_stage_user_login.authentication-login.id
  order  = 100
}

data "authentik_stage" "default-authentication-identification" {
  name = "default-authentication-identification"
}

data "authentik_stage" "default-authentication-password" {
  name = "default-authentication-password"
}

resource "authentik_stage_authenticator_validate" "authentication-mfa-validation" {
  name                  = "authentication-mfa-validation"
  device_classes        = ["static", "totp", "webauthn", "duo", "sms"]
  not_configured_action = "skip"
  last_auth_threshold   = "days=1"
}

resource "authentik_stage_user_login" "authentication-login" {
  name               = "authentication-login"
  remember_me_offset = "days=30"
  session_duration   = "days=7"
}
