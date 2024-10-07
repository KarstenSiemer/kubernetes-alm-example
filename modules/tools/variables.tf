variable "env" {
  type        = string
  description = "The environment to deploy to. e.g. dev, test, prod etc."
  nullable    = false
}

variable "envs" {
  type = map(object({
    http  = number
    https = number
  }))
  description = "Map of environments and their ports"
  nullable    = false
}

variable "resource_prefix" {
  type        = string
  default     = "k8s"
  description = "Prefix for resource names"
  nullable    = false
}

variable "domain" {
  type        = string
  default     = "127.0.0.1.nip.io"
  nullable    = false
  description = "The domain to use for ingress"
}

variable "clusters" {
  type = map(object({
    env       = string
    http      = number
    https     = number
    host      = string
    ca_data   = string
    cert_data = string
    key_data  = string
  }))
  default     = {}
  nullable    = false
  description = "Map of clusters and their configuration"
}

variable "repositories" {
  type = map(object({
    project         = optional(string, "")
    type            = optional(string, "")
    url             = optional(string, "")
    username        = optional(string, "")
    password        = optional(string, "")
    enableOCI       = optional(bool, false)
    ssh_private_key = optional(string, "")
  }))
  default     = {}
  sensitive   = true
  description = "Map of repositories and their configuration"
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
