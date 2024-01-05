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
