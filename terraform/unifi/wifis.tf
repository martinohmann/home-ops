data "unifi_ap_group" "default" {}

data "unifi_user_group" "default" {}

resource "unifi_wlan" "main" {
  name       = "UniFi"
  passphrase = local.secrets.wifi_passwords.main
  security   = "wpapsk"

  network_id    = data.unifi_network.wifi_vlan.id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}

resource "unifi_wlan" "guest" {
  name       = "UniFi Guest"
  passphrase = local.secrets.wifi_passwords.guest
  security   = "wpapsk"

  network_id    = data.unifi_network.guest_vlan.id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}

resource "unifi_wlan" "iot" {
  name       = "UniFi IoT"
  passphrase = local.secrets.wifi_passwords.iot
  security   = "wpapsk"

  network_id    = data.unifi_network.iot_vlan.id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}
