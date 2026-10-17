resource "cloudflare_account_token" "udm" {
  account_id = cloudflare_account.main.id
  name       = "udm"

  policies = [{
    effect = "allow"

    permission_groups = [{
      id = "4755a26eedb94da69e1066d98aa820be" // DNS Write
    }]

    resources = jsonencode({
      "com.cloudflare.api.account.zone.${data.cloudflare_zone.domain.id}" = "*"
    })
  }]
}
