resource "cloudflare_bot_management" "bot_management" {
  zone_id            = data.cloudflare_zone.domain.id
  ai_bots_protection = "block"
}
