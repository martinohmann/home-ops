resource "authentik_property_mapping_provider_scope" "openid-minio" {
  name       = "OAuth Mapping: OpenID minio"
  scope_name = "minio"
  expression = <<-EOF
    if ak_is_group_member(request.user, name="admins"):
        return {
            "policy": "consoleAdmin",
        }
    elif ak_is_group_member(request.user, name="infra"):
        return {
            "policy": "readonly",
        }
    return None
  EOF
}

resource "authentik_property_mapping_provider_scope" "openid-nextcloud" {
  name       = "OAuth Mapping: OpenID nextcloud"
  scope_name = "nextcloud"
  expression = <<-EOF
    group_prefix = "nextcloud-"
    nextcloud_groups = []

    # We only map authentik groups to nextcloud groups that have the
    # `nextcloud-` prefix. The nextcloud group name is the authentik group name
    # with the `nextcloud-` prefix removed.
    for group in user.ak_groups.all():
        if group.name.startswith(group_prefix):
            group_name = group.name.removeprefix(group_prefix)
            nextcloud_groups.append(group_name)

    # Superusers always get assigned to the `admin` group in nextcloud.
    if user.is_superuser and "admin" not in nextcloud_groups:
        nextcloud_groups.append("admin")

    # To set a quota set the "nextcloud_quota" property in the user's or user's
    # group attributes.
    nextcloud_quota = user.group_attributes().get("nextcloud_quota", None)

    return {
        "nextcloud_admin": "admin" in nextcloud_groups,
        "nextcloud_groups": nextcloud_groups,
        "nextcloud_quota": nextcloud_quota
    }
  EOF
}
