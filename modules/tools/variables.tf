variable "env" {
  type        = string
  description = "The environment to deploy to. e.g. dev, test, prod etc."
  nullable    = false
}

variable "envs" {
  type = map(object({
    http               = number
    nodePortHttp       = number
    https              = number
    nodePortHttps      = number
    api_server_address = string
    api_server_port    = number
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

variable "prometheus_remote_write_target" {
  type = string
  description = "The URL to send Prometheus metrics to."
  default = ""
}
