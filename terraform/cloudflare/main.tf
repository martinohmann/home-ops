resource "cloudflare_account" "main" {
  name              = "My main Cloudflare Account"
  type              = "standard"
  enforce_twofactor = false
}

data "cloudflare_zone" "domain" {
  name = "18b.haus"
}
