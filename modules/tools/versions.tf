terraform {
  required_version = ">=1.6.2"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}
