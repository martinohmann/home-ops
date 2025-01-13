resource "authentik_group" "infra" {
  name         = "infra"
  is_superuser = false
}

resource "authentik_group" "admins" {
  name         = "admins"
  is_superuser = true
}

resource "authentik_group" "users" {
  name         = "users"
  is_superuser = false
}

resource "authentik_group" "forgejo" {
  name         = "forgejo"
  is_superuser = false
  parent       = resource.authentik_group.users.id
}

resource "authentik_group" "miniflux" {
  name         = "miniflux"
  is_superuser = false
  parent       = resource.authentik_group.users.id
}

resource "authentik_group" "nextcloud" {
  name         = "nextcloud"
  is_superuser = false
  parent       = resource.authentik_group.users.id
  attributes   = jsonencode({ nexcloud_quota = "10 GB" })
}

resource "authentik_group" "vikunja" {
  name         = "vikunja"
  is_superuser = false
  parent       = resource.authentik_group.users.id
}
