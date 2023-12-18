variable "file" {
  description = "Path to a SOPS encrypted secrets file."
  type        = string
}

variable "key" {
  description = "Key within the secrets to obtain values from."
  type        = string
}
