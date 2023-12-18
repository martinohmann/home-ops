variable "bucket_name" {
  description = "The name of the bucket to create."
  type        = string
}

variable "force_destroy" {
  default     = false
  description = "If true, the bucket can be deleted even if it is not empty."
  type        = bool
}

variable "secret_access_key" {
  default     = null
  description = "The secret access key for the IAM user created to access this bucket. If omitted, a key will be generated."
  type        = string
}
