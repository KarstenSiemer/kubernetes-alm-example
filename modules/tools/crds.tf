resource "kubectl_manifest" "prometheus_crd" {
  for_each          = { for f in fileset(path.module, "/files/crds/prometheus/crd-*.yaml") : regex(".*/crd-(.*).yaml", f)[0] => f }
  server_side_apply = true
  sensitive_fields  = ["spec"]
  yaml_body         = replace(file("${path.module}/${each.value}"), "/creationTimestamp: null/", "")

  timeouts {
    create = "2m"
  }
}
