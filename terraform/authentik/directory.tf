resource "authentik_group" "users" {
  name         = "users"
  is_superuser = false
}

resource "authentik_group" "nextcloud" {
  name         = "nextcloud"
  is_superuser = false
  parent       = resource.authentik_group.users.id
  attributes   = jsonencode({ nexcloud_quota = "10 GB" })
}

resource "authentik_group" "kopia" {
  name         = "kopia"
  is_superuser = false
  parent       = resource.authentik_group.infra.id
  attributes = jsonencode({
    kopia_b2_password    = module.secrets.data.kopia-b2["KOPIA_SERVER_PASSWORD"]
    kopia_b2_username    = module.secrets.data.kopia-b2["KOPIA_SERVER_USERNAME"]
    kopia_local_password = module.secrets.data.kopia-local["KOPIA_SERVER_PASSWORD"]
    kopia_local_username = module.secrets.data.kopia-local["KOPIA_SERVER_USERNAME"]
  })
}

resource "authentik_group" "infra" {
  name         = "infra"
  is_superuser = false
}

resource "authentik_group" "admins" {
  name         = "admins"
  is_superuser = true
}
