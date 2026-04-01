resource "cloudflare_ruleset" "block" {
  zone_id = data.cloudflare_zone.domain.zone_id
  name    = "Block bad actors"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      expression  = "(ip.geoip.country in {\"CN\" \"IN\" \"KP\" \"RU\"})"
      description = "Firewall rule to block countries"
    },
    {
      action      = "block"
      expression  = "(cf.client.bot and (not http.user_agent contains \"UptimeRobot\") and (not http.user_agent contains \"GitHub-Hookshot\")) or (cf.threat_score gt 14)"
      description = "Firewall rule to block bots"
    }
  ]
}
