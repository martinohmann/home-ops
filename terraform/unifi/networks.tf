# @TODO(mohmann): import these at one point.
data "unifi_network" "lan" {
  name = "Default"
}

data "unifi_network" "wifi_vlan" {
  name = "WiFi"
}

data "unifi_network" "guest_vlan" {
  name = "Guest"
}

data "unifi_network" "iot_vlan" {
  name = "IoT"
}

data "unifi_network" "services_vlan" {
  name = "Services"
}
