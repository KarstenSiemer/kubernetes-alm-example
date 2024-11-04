resource "kind_cluster" "default" {
  for_each        = local.envs
  name            = "${local.resource_prefix}-${each.key}"
  wait_for_ready  = true
  kubeconfig_path = pathexpand("~/.kube/config")

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    networking {
      kube_proxy_mode     = "none"
      disable_default_cni = true
      api_server_address  = each.value.api_server_address
      api_server_port     = each.value.api_server_port
    }
    node {
      role = "control-plane"
      kubeadm_config_patches = [
        <<-EOT
          kind: InitConfiguration
          nodeRegistration:
            kubeletExtraArgs:
              node-labels: "ingress-ready=true"
        EOT,
        <<-EOT
          kind: ClusterConfiguration
          apiServer:
            extraArgs:
              enable-admission-plugins: NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook
        EOT
      ]
      extra_port_mappings {
        host_port      = each.value.http
        container_port = each.value.nodePortHttp
        listen_address = each.value.api_server_address
        protocol       = "TCP"
      }
      extra_port_mappings {
        host_port      = each.value.https
        container_port = each.value.nodePortHttps
        listen_address = each.value.api_server_address
        protocol       = "TCP"
      }
    }
    node {
      role = "worker"
      dynamic "extra_mounts" {
        for_each = each.key != "" ? [1] : [] # All clusters require storage
        content {
          host_path      = "${local.shared_volume_path}/${local.resource_prefix}-${each.key}"
          container_path = "/var/local-path-provisioner"
        }
      }
    }
  }
}

locals {
  control_planes = [for k in keys(local.envs) : "${local.resource_prefix}-${k}-control-plane"]
}

# Required script for ArgoCD to gether the internal docker bridge IP addresses from the control plane
# It is not easily possible in KinD to predefine the IP addresses of the control planes,
# so we need to run a script that will discover them
# Run as:
# bash ./get_control_plane_ips.bash ba-dev-control-plane ba-prod-control-plane ba-test-control-plane ba-tools-control-plane
# Outputs as:
#{
#  "ba-prod-control-plane": "172.18.0.8",
#  "ba-test-control-plane": "172.18.0.4",
#  "ba-tools-control-plane": "172.18.0.6"
#}
data "external" "cluster_internal_control_plane_ip" {
  program    = concat(["bash", "${path.module}/get_control_plane_ips.bash"], local.control_planes)
  depends_on = [kind_cluster.default]
}
