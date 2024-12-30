resource "helm_release" "ingress_nginx" {
  cleanup_on_fail   = false
  force_update      = true
  dependency_update = true
  lint              = true
  name              = "ingress-nginx"
  namespace         = "kube-system"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  version           = "4.12.0"
  timeout           = 900
  wait_for_jobs     = true

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [
    helm_release.cilium,
  ]

  values = [yamlencode({
    controller = {
      updateStrategy = {
        type = "RollingUpdate"
        rollingUpdate = {
          maxUnavailable = 1
        }
      }
      hostPort = {
        enabled = false
      }
      terminationGracePeriodSeconds = 0
      service = {
        type = "NodePort"
        nodePorts = {
          http  = var.envs[var.env].nodePortHttp
          https = var.envs[var.env].nodePortHttps
        }
      }
      watchIngressWithoutClass = true
      nodeSelector = {
        ingress-ready = "true"
      }
      tolerations = [
        {
          key      = "node-role.kubernetes.io/master"
          operator = "Equal"
          effect   = "NoSchedule"
        },
        {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Equal"
          effect   = "NoSchedule"
        }
      ]
      publishService = {
        enabled = false
      }
      extraArgs = {
        publish-status-address = "localhost"
      }
    }
  })]
}
