resource "cloudflare_ruleset" "block" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "Block bad actors"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules {
    action      = "block"
    expression  = "(ip.geoip.country in {\"CN\" \"IN\" \"KP\" \"RU\"})"
    description = "Firewall rule to block countries"
  }

  rules {
    action      = "block"
    expression  = "(cf.client.bot) or (cf.threat_score gt 14)"
    description = "Firewall rule to block bots"
  }
}
