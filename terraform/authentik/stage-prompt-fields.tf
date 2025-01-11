resource "authentik_stage_prompt_field" "password" {
  name          = "password"
  field_key     = "password"
  type          = "password"
  label         = "Password"
  placeholder   = "Password"
  initial_value = "Password"
  required      = true
  order         = 300
}

resource "authentik_stage_prompt_field" "password-repeat" {
  name          = "password-repeat"
  field_key     = "password-repeat"
  type          = "password"
  placeholder   = "Password (repeat)"
  label         = "Password (repeat)"
  initial_value = "Password (repeat)"
  required      = true
  order         = 301
}
