locals {
  server_address = "127.0.0.1"
  envs = {
    tools = { http = 8080, https = 8443, api_server_address = local.server_address, api_server_port = 63788 }
    dev   = { http = 7080, https = 7443, api_server_address = local.server_address, api_server_port = 63787 }
    test  = { http = 6080, https = 6443, api_server_address = local.server_address, api_server_port = 63785 }
    prod  = { http = 5080, https = 5443, api_server_address = local.server_address, api_server_port = 63786 }
  }
  resource_prefix    = "ba"
  shared_volume_path = pathexpand("${path.cwd}/shared-volume")
}
