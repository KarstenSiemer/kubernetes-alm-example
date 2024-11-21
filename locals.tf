locals {
  server_address = "127.0.0.1"
  envs = {
    tools = { http = 8080, nodePortHttp = 30880, https = 8443, nodePortHttps = 30843, api_server_address = local.server_address, api_server_port = 63788 }
    dev   = { http = 7080, nodePortHttp = 30780, https = 7443, nodePortHttps = 30743, api_server_address = local.server_address, api_server_port = 63787 }
    test  = { http = 6080, nodePortHttp = 30680, https = 6443, nodePortHttps = 30643, api_server_address = local.server_address, api_server_port = 63785 }
    prod  = { http = 5080, nodePortHttp = 30580, https = 5443, nodePortHttps = 30543, api_server_address = local.server_address, api_server_port = 63786 }
  }
  env_prometheus_remote_write_target = data.external.cluster_internal_control_plane_ip.result["${local.resource_prefix}-tools-control-plane"]
  resource_prefix    = "ba"
  shared_volume_path = pathexpand("${path.cwd}/shared-volume")
}
