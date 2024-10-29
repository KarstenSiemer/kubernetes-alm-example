resource "helm_release" "cilium" {
  cleanup_on_fail   = false
  force_update      = true
  dependency_update = true
  lint              = true
  name              = "cilium"
  namespace         = "kube-system"
  repository        = "https://helm.cilium.io"
  chart             = "cilium"
  timeout           = 900
  wait_for_jobs     = true

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [kubectl_manifest.prometheus_crd]

  values = [
    yamlencode({
      kubeProxyReplacement = true
      k8sServiceHost       = "${var.resource_prefix}-${var.env}-control-plane"
      k8sServicePort       = 6443
      hostServices = {
        enabled = false
      }
      externalIPs = {
        enabled = true
      }
      nodePort = {
        enabled = true
      }
      hostPort = {
        enabled = true
      }
      image = {
        pullPolicy = "IfNotPresent"
      }
      ipam = {
        mode = "kubernetes"
      }
      hubble = {
        enabled = true
        relay = {
          enabled = true
        }
        ui = {
          enabled = true
          ingress = {
            enabled   = true
            className = "nginx"
            hosts     = ["hubble-ui.${var.env}.${var.domain}"]
          }
        }
      }
    })
  ]
}
