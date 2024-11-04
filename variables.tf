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

variable "github_app_id" {
  type        = string
  description = "The ID of the GitHub app."
  default     = ""
}

variable "github_app_private_key" {
  type        = string
  description = "The private key used to connect to the GitHub."
  default     = ""
}

variable "github_app_installation_id" {
  type        = string
  description = "The installation id of the GitHub app."
  default     = ""
}
