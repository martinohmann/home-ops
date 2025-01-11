data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-invalidation-flow" {
  slug = "default-invalidation-flow"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default-user-settings-flow" {
  slug = "default-user-settings-flow"
}

// Authentication
resource "authentik_flow" "authentication-flow" {
  name        = "Welcome to authentik!"
  title       = "Welcome to authentik!"
  slug        = "authentication-flow"
  designation = "authentication"
  background  = "/static/dist/assets/images/flow_background.jpg"
}

resource "authentik_flow_stage_binding" "authentication-identification" {
  target = authentik_flow.authentication-flow.uuid
  stage  = authentik_stage_identification.authentication-identification.id
  order  = 10
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

// Recovery
resource "authentik_flow" "recovery" {
  name               = "recovery-flow"
  title              = "Password recovery"
  slug               = "password-recovery"
  designation        = "recovery"
  compatibility_mode = true
}

resource "authentik_flow_stage_binding" "recovery-flow-binding-00" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_identification.recovery-identification.id
  order  = 0
}

resource "authentik_flow_stage_binding" "recovery-flow-binding-10" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_email.recovery-email.id
  order  = 10
}

resource "authentik_flow_stage_binding" "recovery-flow-binding-20" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_prompt.password-change-prompt.id
  order  = 20
}

resource "authentik_flow_stage_binding" "recovery-flow-binding-30" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_user_write.password-change-write.id
  order  = 30
}
