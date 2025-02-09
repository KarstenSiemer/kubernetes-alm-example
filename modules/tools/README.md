<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.argocd_apps](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.argocd_projects](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.cilium](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.prometheus-operator](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.renovate](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [kubectl_manifest.prometheus_crd](https://registry.terraform.io/providers/alekc/kubectl/2.1.3/docs/resources/manifest) | resource |
| [kubernetes_secret.argocd_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/secret) | resource |
| [random_password.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.renovate_admin_api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_static.argocd_admin_password_mtime](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Map of clusters and their configuration | <pre>map(object({<br/>    env       = string<br/>    http      = number<br/>    https     = number<br/>    host      = string<br/>    ca_data   = string<br/>    cert_data = string<br/>    key_data  = string<br/>  }))</pre> | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain to use for ingress | `string` | `"127.0.0.1.nip.io"` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment to deploy to. e.g. dev, test, prod etc. | `string` | n/a | yes |
| <a name="input_envs"></a> [envs](#input\_envs) | Map of environments and their ports | <pre>map(object({<br/>    http               = number<br/>    nodePortHttp       = number<br/>    https              = number<br/>    nodePortHttps      = number<br/>    api_server_address = string<br/>    api_server_port    = number<br/>  }))</pre> | n/a | yes |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | The ID of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | The installation id of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_private_key"></a> [github\_app\_private\_key](#input\_github\_app\_private\_key) | The private key used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_github_password"></a> [github\_password](#input\_github\_password) | The password used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_prometheus_remote_write_target"></a> [prometheus\_remote\_write\_target](#input\_prometheus\_remote\_write\_target) | The URL to send Prometheus metrics to. | `string` | `""` | no |
| <a name="input_renovatebot_license"></a> [renovatebot\_license](#input\_renovatebot\_license) | The RenovateBot license key. | `string` | `""` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of repositories and their configuration | <pre>map(object({<br/>    project         = optional(string, "")<br/>    type            = optional(string, "")<br/>    url             = optional(string, "")<br/>    username        = optional(string, "")<br/>    password        = optional(string, "")<br/>    enableOCI       = optional(bool, false)<br/>    ssh_private_key = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix for resource names | `string` | `"k8s"` | no |
| <a name="input_server_secret_key"></a> [server\_secret\_key](#input\_server\_secret\_key) | The secret key used to encrypt secrets in the server. | `string` | `""` | no |
| <a name="input_user_info"></a> [user\_info](#input\_user\_info) | The user and group ids to use for the server. | <pre>object({<br/>    user_id  = optional(string, "1001")<br/>    group_id = optional(string, "2001")<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
