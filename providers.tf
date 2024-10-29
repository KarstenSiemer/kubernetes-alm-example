provider "kind" {}

##########
# tools
##########

provider "helm" {
  alias = "tools"
  kubernetes {
    host = kind_cluster.default["tools"].endpoint

    client_certificate     = kind_cluster.default["tools"].client_certificate
    client_key             = kind_cluster.default["tools"].client_key
    cluster_ca_certificate = kind_cluster.default["tools"].cluster_ca_certificate
  }
}

provider "kubectl" {
  alias = "tools"

  host = kind_cluster.default["tools"].endpoint

  client_certificate     = kind_cluster.default["tools"].client_certificate
  client_key             = kind_cluster.default["tools"].client_key
  cluster_ca_certificate = kind_cluster.default["tools"].cluster_ca_certificate
}

provider "kubernetes" {
  alias = "tools"

  host = kind_cluster.default["tools"].endpoint

  client_certificate     = kind_cluster.default["tools"].client_certificate
  client_key             = kind_cluster.default["tools"].client_key
  cluster_ca_certificate = kind_cluster.default["tools"].cluster_ca_certificate
}

##########
# dev
##########

provider "helm" {
  alias = "dev"
  kubernetes {
    host = kind_cluster.default["dev"].endpoint

    client_certificate     = kind_cluster.default["dev"].client_certificate
    client_key             = kind_cluster.default["dev"].client_key
    cluster_ca_certificate = kind_cluster.default["dev"].cluster_ca_certificate
  }
}

provider "kubectl" {
  alias = "dev"

  host = kind_cluster.default["dev"].endpoint

  client_certificate     = kind_cluster.default["dev"].client_certificate
  client_key             = kind_cluster.default["dev"].client_key
  cluster_ca_certificate = kind_cluster.default["dev"].cluster_ca_certificate
}

provider "kubernetes" {
  alias = "dev"

  host = kind_cluster.default["dev"].endpoint

  client_certificate     = kind_cluster.default["dev"].client_certificate
  client_key             = kind_cluster.default["dev"].client_key
  cluster_ca_certificate = kind_cluster.default["dev"].cluster_ca_certificate
}

##########
# test
##########

provider "helm" {
  alias = "test"
  kubernetes {
    host = kind_cluster.default["test"].endpoint

    client_certificate     = kind_cluster.default["test"].client_certificate
    client_key             = kind_cluster.default["test"].client_key
    cluster_ca_certificate = kind_cluster.default["test"].cluster_ca_certificate
  }
}

provider "kubectl" {
  alias = "test"

  host = kind_cluster.default["test"].endpoint

  client_certificate     = kind_cluster.default["test"].client_certificate
  client_key             = kind_cluster.default["test"].client_key
  cluster_ca_certificate = kind_cluster.default["test"].cluster_ca_certificate
}

provider "kubernetes" {
  alias = "test"

  host = kind_cluster.default["test"].endpoint

  client_certificate     = kind_cluster.default["test"].client_certificate
  client_key             = kind_cluster.default["test"].client_key
  cluster_ca_certificate = kind_cluster.default["test"].cluster_ca_certificate
}


##########
# prod
##########

provider "helm" {
  alias = "prod"
  kubernetes {
    host = kind_cluster.default["prod"].endpoint

    client_certificate     = kind_cluster.default["prod"].client_certificate
    client_key             = kind_cluster.default["prod"].client_key
    cluster_ca_certificate = kind_cluster.default["prod"].cluster_ca_certificate
  }
}

provider "kubectl" {
  alias = "prod"

  host = kind_cluster.default["prod"].endpoint

  client_certificate     = kind_cluster.default["prod"].client_certificate
  client_key             = kind_cluster.default["prod"].client_key
  cluster_ca_certificate = kind_cluster.default["prod"].cluster_ca_certificate
}

provider "kubernetes" {
  alias = "prod"

  host = kind_cluster.default["prod"].endpoint

  client_certificate     = kind_cluster.default["prod"].client_certificate
  client_key             = kind_cluster.default["prod"].client_key
  cluster_ca_certificate = kind_cluster.default["prod"].cluster_ca_certificate
}
