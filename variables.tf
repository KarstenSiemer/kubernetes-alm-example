variable "github_ssh_private_key" {
  type        = string
  default     = ""
  description = "The private key used to connect to the GitHub."
}

variable "github_password" {
  type        = string
  default     = ""
  description = "The password used to connect to the GitHub."
}

variable "server_secret_key" {
  type        = string
  default     = ""
  description = "The secret key used to encrypt secrets in the server."
}
