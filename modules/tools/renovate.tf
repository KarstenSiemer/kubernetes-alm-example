resource "random_password" "renovate_admin_api" {
  count   = local.install_tools_cluster ? 1 : 0
  length  = 8
  special = true
}

resource "helm_release" "renovate" {
  count = 0

  cleanup_on_fail   = false
  force_update      = false
  dependency_update = true
  lint              = true
  name              = "renovate"
  namespace         = "renovate"
  repository        = "https://mend.github.io/renovate-ce-ee"
  chart             = "mend-renovate-ce"
  version           = "9.1.1"
  timeout           = 900
  wait_for_jobs     = true
  create_namespace  = true

  lifecycle {
    ignore_changes = [metadata]
  }

  values = [
    yamlencode({
      renovate = {
        mendRnvAcceptTos              = "y"
        mendRnvPlatform               = "github"
        mendRnvEndpoint               = "https://api.github.com/"
        mendRnvCronJobSchedulerAll    = "*/10 * * * *" # every 10 minutes
        mendRnvAdminApiEnabled        = true
        mendRnvLogHistoryTTLDays      = "1"
        logLevel                      = "info"
        mendRnvWorkerExecutionTimeout = "2000"
      }
    }),
    yamlencode({
      renovate = {
        config = <<-EOF
          module.exports = {
          }
        EOF
      }
    }),
    sensitive(yamlencode({
      renovate = {
        mendRnvLicenseKey      = var.renovatebot_license
        mendRnvGithubAppId     = tostring(var.github_app_id)
        mendRnvGithubAppKey    = var.github_app_private_key
        githubComToken         = var.github_password
        mendRnvServerApiSecret = random_password.renovate_admin_api[0].result
      }
    })),
    yamlencode({
      cachePersistence = {
        enabled      = false
        storageClass = "standard"
        size         = "10Gi"
      }
    }),
    yamlencode({
      ingress = {
        enabled          = true
        hosts            = ["renovate.${var.env}.${var.domain}"]
        ingressClassName = "nginx"
      }
    }),
    yamlencode({
      serviceAccount = {
        create = true
      }
    }),
    yamlencode({
      resources = {
        requests = {
          cpu    = "400m"
          memory = "1Gi"
        }
      }
    }),
    yamlencode({
      livenessProbe = {
        initialDelaySeconds = 90
        periodSeconds       = 20
        timeoutSeconds      = 3
      }
    }),
    yamlencode({
      podSecurityContext = {
        runAsNonRoot = true
      }
    }),
    yamlencode({
      containerSecurityContext = {
        runAsUser  = tonumber(var.user_info.user_id)
        runAsGroup = tonumber(var.user_info.user_id)
        fsGroup    = tonumber(var.user_info.user_id)
      }
    }),
  ]
}
