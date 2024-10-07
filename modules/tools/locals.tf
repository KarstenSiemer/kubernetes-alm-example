locals {
  install_env_cluster      = var.env != "tools"
  install_tools_cluster    = var.env == "tools"
  service_monitor_selector = {}
  cluster_credentials = { for k, v in var.clusters : k => {
    name    = k
    project = v.env
    server  = v.host
    labels = {
      (v.env) = "true"
      env     = "true"
      http    = tostring(v.http)
      https   = tostring(v.https)
    }
    config = {
      tlsClientConfig = {
        insecure = false
        caData   = base64encode(v.ca_data)
        certData = base64encode(v.cert_data)
        keyData  = base64encode(v.key_data)
      }
    }
  } if k != "tools" }
  repositories = { for k, v in var.repositories : nonsensitive(k) => merge(
    {
      name = nonsensitive(k)
      url  = nonsensitive(v.url),
    },
    length(v.project) > 0 ? {
      project = nonsensitive(v.project),
    } : {},
    length(v.type) > 0 ? {
      type = nonsensitive(v.type),
    } : {},
    length(v.username) > 0 ? {
      username = nonsensitive(v.username),
    } : {},
    length(v.type) > 0 ? {
      enableOCI = v.type == "helm" ? "true" : "false"
    } : {},
    )
  }

  projects = { for k in keys(var.envs) : k => {
    roles       = []
    namespace   = "argocd"
    description = "Project of ${k}"
    sourceRepos = ["*"]
    destinations = [
      {
        name      = "*"
        server    = "*"
        namespace = "*"
      },
    ]
    additionalLabels = {
      env = k
    }
    clusterResourceWhitelist = [
      {
        group = ""
        kind  = "Namespace"
      }
    ]
    namespaceResourceBlacklist = [
      {
        group = "argoproj.io"
        kind  = "AppProject"
      }
    ]
    orphanedResources = {
      warn = true
    }
    permitOnlyProjectScopedClusters = k != "tools" ? true : false
  } }

  applications = { "seeder" = {
    namespace = "argocd"
    project   = "tools"
    source = {
      repoURL        = "git@github.com:KarstenSiemer/BMMI.git"
      targetRevision = "main"
      path           = "deploy/"
    }
    destination = {
      name      = "in-cluster"
      namespace = "argocd"
    }
    syncPolicy = {
      automated = {
        prune    = true
        selfHeal = true
      }
    }
  } }
}
