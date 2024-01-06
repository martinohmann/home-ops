resource "authentik_scope_mapping" "openid-minio" {
  name       = "OAuth Mapping: OpenID minio"
  scope_name = "minio"
  expression = <<-EOF
    if ak_is_group_member(request.user, name="admins"):
        return {
            "policy": "consoleAdmin",
        }
    elif ak_is_group_member(request.user, name="users"):
        return {
            "policy": "readonly",
        }
    return None
  EOF
}

resource "authentik_scope_mapping" "openid-nextcloud" {
  name       = "OAuth Mapping: OpenID nextcloud"
  scope_name = "nextcloud"
  expression = <<-EOF
    # Extract all groups the user is a member of
    groups = [group.name for group in user.ak_groups.all()]

    # Nextcloud admins must be members of a group called "admin".
    # This is static and cannot be changed.
    # We append a fictional "admin" group to the user's groups if they are an admin in authentik.
    # This group would only be visible in Nextcloud and does not exist in authentik.
    if user.is_superuser and "admin" not in groups:
        groups.append("admin")

    return {
        "is_admin": "admin" in groups,
        "name": request.user.name,
        "groups": groups,
        # To set a quota set the "nextcloud_quota" property in the user's attributes
        "quota": user.group_attributes().get("nextcloud_quota", None)
    }
  EOF
}
