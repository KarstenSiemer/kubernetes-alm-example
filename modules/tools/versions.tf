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
