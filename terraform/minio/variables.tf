variable "secret_access_keys" {
  description = "A map of user name to secret access key."
  sensitive   = true
  type        = map(string)
}
