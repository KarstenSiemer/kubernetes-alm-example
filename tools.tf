module "tools_tools" {
  source = "./modules/tools"
  providers = {
    helm       = helm.tools
    kubectl    = kubectl.tools
    kubernetes = kubernetes.tools
  }
  env             = "tools"
  envs            = local.envs
  resource_prefix = local.resource_prefix
  clusters = { for k, v in local.envs : k =>
    {
      env = k
      http = v.http
      https = v.https
      # KinD provider returns cluster hosts as localhost, which ArgoCD cannot reach (logically)
      # Pass docker brige IP, which is reachable via ArgoCD with nodePort
      host      = join("", ["https://", data.external.cluster_internal_control_plane_ip.result["${local.resource_prefix}-${k}-control-plane"], ":6443"]) #kind_cluster.default[k].endpoint
      ca_data   = kind_cluster.default[k].cluster_ca_certificate
      cert_data = kind_cluster.default[k].client_certificate
      key_data  = kind_cluster.default[k].client_key
    }
  }
  repositories = {
    bmmi = {
      url             = "git@github.com:KarstenSiemer/BMMI.git"
      ssh_private_key = var.github_ssh_private_key
      username        = "KarstenSiemer"
    }
  }
  github_password   = var.github_password
  server_secret_key = var.server_secret_key
}

module "tools_dev" {
  source = "./modules/tools"
  providers = {
    helm       = helm.dev
    kubectl    = kubectl.dev
    kubernetes = kubernetes.dev
  }
  env             = "dev"
  envs            = local.envs
  resource_prefix = local.resource_prefix
}

module "tools_test" {
  source = "./modules/tools"
  providers = {
    helm       = helm.test
    kubectl    = kubectl.test
    kubernetes = kubernetes.test
  }
  env             = "test"
  envs            = local.envs
  resource_prefix = local.resource_prefix
}

module "tools_prod" {
  source = "./modules/tools"
  providers = {
    helm       = helm.prod
    kubectl    = kubectl.prod
    kubernetes = kubernetes.prod
  }
  env             = "prod"
  envs            = local.envs
  resource_prefix = local.resource_prefix
}
