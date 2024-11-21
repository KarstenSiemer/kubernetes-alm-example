# kubernetes-alm-example

Example flow for application lifecycles on kubernetes

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [kind_cluster.default](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [external_external.cluster_internal_control_plane_ip](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | The ID of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | The installation id of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_private_key"></a> [github\_app\_private\_key](#input\_github\_app\_private\_key) | The private key used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_github_password"></a> [github\_password](#input\_github\_password) | The password used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_github_ssh_private_key"></a> [github\_ssh\_private\_key](#input\_github\_ssh\_private\_key) | The private key used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_server_secret_key"></a> [server\_secret\_key](#input\_server\_secret\_key) | The secret key used to encrypt secrets in the server. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
