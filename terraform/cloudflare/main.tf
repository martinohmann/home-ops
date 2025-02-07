resource "cloudflare_account" "main" {
  name = "My main Cloudflare Account"
  type = "standard"
  settings = {
    enforce_twofactor = false
  }
}

data "cloudflare_zones" "domain" {
  name = "18b.haus"
}

// See: https://github.com/cloudflare/terraform-provider-cloudflare/issues/4958
data "cloudflare_zone" "domain" {
  zone_id = data.cloudflare_zones.domain.result[0].id
}
