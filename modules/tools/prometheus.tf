resource "time_sleep" "wait_30_seconds" { # Wait a little and hope ingress admission hook is ready
  depends_on = [
    helm_release.cilium,
    helm_release.ingress_nginx
  ]

  create_duration = "30s"
}

resource "helm_release" "prometheus-operator" {
  cleanup_on_fail   = false
  force_update      = true
  dependency_update = true
  lint              = true
  name              = "prometheus"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "kube-prometheus-stack"
  version           = "65.0.0"
  namespace         = "monitoring"
  create_namespace  = true
  timeout           = 900
  skip_crds         = true
  wait_for_jobs     = true

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [
    helm_release.cilium,
    helm_release.ingress_nginx,
    time_sleep.wait_30_seconds
  ]

  values = [yamlencode({
    prometheus = {
      agentMode = local.install_env_cluster
      service = {
        sessionAffinity = "ClientIP"
      }
      prometheusSpec = {
        retention                               = "1h"
        retentionSize                           = "1GB"
        externalUrl                             = "http://prometheus.${var.env}.${var.domain}"
        ruleSelectorNilUsesHelmValues           = false
        serviceMonitorSelectorNilUsesHelmValues = false
        podMonitorSelectorNilUsesHelmValues     = false
        probeSelectorNilUsesHelmValues          = false
        scrapeConfigSelectorNilUsesHelmValues   = false
        logFormat                               = "json"
        enableRemoteWriteReceiver               = local.install_tools_cluster
        remoteWrite = local.install_env_cluster ? [
          {
            url  = "http://prometheus.tools.${var.domain}:${var.envs.tools.http}/api/v1/write"
            name = "tools"
          }
        ] : []
        remoteWriteDashboards = local.install_env_cluster
      }
      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        hosts            = ["prometheus.${var.env}.${var.domain}"]
        pathType         = "Prefix"
      }
    }
    }),
    yamlencode({
      grafana = {
        enabled = local.install_tools_cluster
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          hosts            = ["grafana.${var.env}.${var.domain}"]
          pathType         = "Prefix"
        }
      }
    }),
    yamlencode({
      alertmanager = {
        enabled = false
      }
    }),
    yamlencode({
      cleanPrometheusOperatorObjectNames = true
    }),
    yamlencode({
      nodeExporter = {
        enabled = false
      }
    }),
    yamlencode({
      kubeProxy = {
        enabled = false
      }
    }),
    yamlencode({
      kubeScheduler = {
        enabled = false
      }
    }),
    yamlencode({
      kubeEtcd = {
        enabled = false
      }
    }),
    yamlencode({
      kubeControllerManager = {
        enabled = false
      }
    }),
    yamlencode({
      kubelet = {
        enabled = false
      }
    }),
    yamlencode({
      kubeApiServer = {
        enabled = false
      }
    }),
  ]
}
