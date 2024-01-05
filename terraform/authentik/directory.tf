resource "authentik_group" "users" {
  name         = "users"
  is_superuser = false
}

resource "authentik_group" "admins" {
  name         = "admins"
  is_superuser = true
}
