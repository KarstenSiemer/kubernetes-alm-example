resource "random_password" "argocd_admin_password" {
  count   = local.install_tools_cluster ? 1 : 0
  length  = 40
  special = true
}

# Create an MTime since last password change
resource "time_static" "argocd_admin_password_mtime" {
  count = local.install_tools_cluster ? 1 : 0

  triggers = {
    bcrypt   = bcrypt(random_password.argocd_admin_password[0].result)
    password = sha512(random_password.argocd_admin_password[0].result)
  }

  lifecycle {
    ignore_changes = [triggers["bcrypt"]]
  }
}

resource "kubernetes_secret" "argocd_admin" {
  count = local.install_tools_cluster ? 1 : 0

  metadata {
    name      = "argocd-admin"
    namespace = "argocd"
  }

  data = {
    username     = "admin"
    password     = random_password.argocd_admin_password[0].result
    last-changed = time_static.argocd_admin_password_mtime[0].rfc3339
  }

  type = "Opaque"

  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd" {
  count = local.install_tools_cluster ? 1 : 0

  cleanup_on_fail   = false
  force_update      = true
  dependency_update = true
  lint              = true
  namespace         = "argocd"
  name              = "argocd"
  version           = "7.8.2"
  chart             = "argo-cd"
  repository        = "https://argoproj.github.io/argo-helm"
  create_namespace  = true
  atomic            = false
  timeout           = 900

  depends_on = [
    helm_release.cilium,
    helm_release.ingress_nginx
  ]

  lifecycle {
    ignore_changes = [metadata]
  }

  values = [
    yamlencode({
      createAggregateRoles = true
    }),
    yamlencode({
      crds = {
        install = true
      }
    }),
    yamlencode({
      global = {
        logging = {
          format = "json"
        }
        domain = "argocd.${var.env}.${var.domain}"
      }
    }),
    yamlencode({
      configs = {
        cm = {
          url                              = "http://argocd.${var.env}.${var.domain}:8080"
          "exec.enabled"                   = true
          "server.rbac.log.enforce.enable" = true
          "admin.enabled"                  = true
          "statusbadge.enabled"            = true
        }
      }
    }),
    yamlencode({
      configs = {
        params = {
          create                                              = true
          "server.insecure"                                   = true
          "applicationsetcontroller.enable.progressive.syncs" = true
        }
      }
    }),
    yamlencode({
      configs = {
        rbac = {
          create = true
        }
      }
    }),
    yamlencode({
      controller = {
        enableStatefulSet = true
      }
    }),
    yamlencode({
      controller = {
        metrics = {
          enabled = true
          serviceMonitor = {
            enabled  = true
            selector = local.service_monitor_selector
          },
        },
      }
    }),
    yamlencode({
      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          hostname         = "argocd.${var.env}.${var.domain}"
        }
        service = {
          sessionAffinity = "ClientIP"
        }
      }
    }),
    yamlencode({
      configs = {
        clusterCredentials = local.cluster_credentials
      }
    }),
    yamlencode({
      configs = {
        repositories = nonsensitive(local.repositories)
      }
    }),
    # Argo Notification
    yamlencode({
      notifications = {
        logFormat = "json"
      }
    }),
    yamlencode({
      notifications = {
        argocdUrl = "http://argocd.${var.env}.${var.domain}:8080"
      }
    }),
    yamlencode({
      notifications = {
        notifiers = local.notifications_notifiers
      }
    }),
    yamlencode({
      notifications = {
        templates = local.notifications_templates
      }
    }),
    yamlencode({
      notifications = {
        triggers = local.notifications_triggers
      }
    }),
    yamlencode({
      notifications = {
        subscriptions = local.notifications_subscriptions_defaults
      }
    }),
  ]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = time_static.argocd_admin_password_mtime[0].triggers.bcrypt
  }

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPasswordMtime"
    value = time_static.argocd_admin_password_mtime[0].rfc3339
  }

  dynamic "set_sensitive" {
    for_each = length(var.github_password) > 0 ? [1] : []
    content {
      name  = "configs.secret.githubSecret"
      value = var.github_password
    }
  }

  dynamic "set_sensitive" {
    for_each = length(var.server_secret_key) > 0 ? [1] : []
    content {
      name  = "configs.secret.extra.server\\.secretkey"
      value = var.server_secret_key
    }
  }

  dynamic "set_sensitive" {
    for_each = toset([for k, v in nonsensitive(var.repositories) : k if length(v.password) > 0 && v.ssh_private_key == ""])
    content {
      name  = "configs.repositories.${set_sensitive.key}.password"
      value = var.repositories[set_sensitive.key].password
    }
  }

  dynamic "set_sensitive" {
    for_each = toset([for k, v in nonsensitive(var.repositories) : k if length(v.ssh_private_key) > 0])
    content {
      name  = "configs.repositories.${set_sensitive.key}.sshPrivateKey"
      value = var.repositories[set_sensitive.key].ssh_private_key
    }
  }

  dynamic "set_sensitive" {
    for_each = local.notifications_app_enabled ? [1] : []
    content {
      name  = "notifications.secret.items.github-app-privateKey"
      value = var.github_app_private_key
    }
  }

}

resource "helm_release" "argocd_projects" {
  count = local.install_tools_cluster ? 1 : 0

  cleanup_on_fail   = true
  force_update      = true
  dependency_update = true
  lint              = true
  namespace         = "argocd"
  name              = "argocd-projects"
  version           = "2.0.2"
  chart             = "argocd-apps"
  repository        = "https://argoproj.github.io/argo-helm"
  create_namespace  = false
  atomic            = false
  timeout           = 800

  lifecycle {
    ignore_changes = [metadata]
  }

  values = [for k, v in local.projects : yamlencode({ projects = { (k) = v } })]

  depends_on = [
    helm_release.argocd
  ]
  max_history = 3
}

resource "helm_release" "argocd_apps" {
  count = local.install_tools_cluster ? 1 : 0

  cleanup_on_fail   = true
  force_update      = true
  dependency_update = true
  lint              = true
  namespace         = "argocd"
  name              = "argocd-apps"
  version           = "2.0.2"
  chart             = "argocd-apps"
  repository        = "https://argoproj.github.io/argo-helm"
  create_namespace  = false
  atomic            = false
  timeout           = 800

  lifecycle {
    ignore_changes = [metadata]
  }

  values = [for k, v in local.applications : yamlencode({ applications = { (k) = v } })]

  depends_on = [
    helm_release.argocd
  ]
  max_history = 3
}
