locals {
  # Trim CIDR suffix.
  ip_address = replace(var.ip_address, "/\\/[0-9]{1, 2}$/", "")

  ip_address_hash = sha256(var.ip_address)

  ip_address_octets = [for octet in split(".", local.ip_address) : parseint(octet, 10)]
  ip_address_hash_octets = [
    for octet in [substr(local.ip_address_hash, 0, 2), substr(local.ip_address_hash, 2, 2)] :
    parseint(octet, 16)
  ]

  # The prefix consists of the 4 octets of the IPv4 address and the
  # first 2 octects of its hash.
  prefix = concat(local.ip_address_octets, local.ip_address_hash_octets)
}

resource "macaddress" "stable" {
  prefix = local.prefix
}
