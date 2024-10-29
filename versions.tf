terraform {
  required_version = ">=1.6.2"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.1"
    }
    #http = {
    #  source  = "hashicorp/http"
    #  version = "~> 3"
    #}
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    #null = {
    #  source  = "hashicorp/null"
    #  version = "~> 3"
    #}
    time = {
      source  = "hashicorp/time"
      version = "~> 0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2"
    }
  }
}
