// Authentication
resource "authentik_stage_identification" "authentication-identification" {
  name                      = "authentication-identification"
  user_fields               = ["username", "email"]
  case_insensitive_matching = false
  show_source_labels        = true
  show_matched_user         = false
  password_stage            = data.authentik_stage.default-authentication-password.id
  recovery_flow             = authentik_flow.recovery.uuid
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

// Recovery
resource "authentik_stage_identification" "recovery-identification" {
  name                      = "recovery-identification"
  user_fields               = ["username", "email"]
  case_insensitive_matching = false
  show_source_labels        = false
  show_matched_user         = false
}

resource "authentik_stage_email" "recovery-email" {
  name                     = "recovery-email"
  activate_user_on_success = true
  use_global_settings      = true
  template                 = "email/password_reset.html"
  subject                  = "Password recovery"
}

resource "authentik_stage_prompt" "password-change-prompt" {
  name = "password-change-prompt"
  fields = [
    authentik_stage_prompt_field.password.id,
    authentik_stage_prompt_field.password-repeat.id
  ]
  validation_policies = [
    authentik_policy_password.password-complexity.id
  ]
}

resource "authentik_stage_user_write" "password-change-write" {
  name                     = "password-change-write"
  create_users_as_inactive = false
}
