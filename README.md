# kubernetes-alm-example

Example flow for application lifecycles on kubernetes

Hier kommt Terraform zur Anwendung. Zur Erstellung der Ressourcen muss der Cache mittels eines `terraform init`
populiert werden. Danach kann ein Plan mittels `terraform plan` durchgeführt werden. Dieser sollte die Erstellung von 67
Ressourcen vorsehen. Die Erstellung kann mit `terraform apply` ausgelöst werden.

Das Erstellen sollte ca. 30 Minuten in Anspruch nehmen.

Falls eine Fehlermeldung auftritt, welche "Ports are not available" enthält, so kann folgendes probiert werden:

```bash
/Applications/Docker.app/Contents/MacOS/install remove-vmnetd
sudo /Applications/Docker.app/Contents/MacOS/install vmnetd
```

Der Großteil der Funktionalität wird über ArgoCD hergestellt. Das admin Userpasswort ist in dem argocd Namespace des
tools clusters zu finden.

Die Konnektivität wird über localhost (127.0.0.1) hergestellt. Zur effektiven Verwendung des Ingresses der Cluster, wird
nip.io verwendet.

Weiterhin muss für MacOS Systeme die von z.B. Docker Desktop bereitgestellte Virtuelle Machine, erheblich in Ressourcen
(CPU/MEM/DISK) erhöht werden. Ich habe aktuell 12 CPU, 30GB Mem und 200GB Disk zugesichert.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [kind_cluster.default](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [external_external.cluster_internal_control_plane_ip](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.user_info](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | The ID of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | The installation id of the GitHub app. | `string` | `""` | no |
| <a name="input_github_app_private_key"></a> [github\_app\_private\_key](#input\_github\_app\_private\_key) | The private key used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_github_password"></a> [github\_password](#input\_github\_password) | The password used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_github_ssh_private_key"></a> [github\_ssh\_private\_key](#input\_github\_ssh\_private\_key) | The private key used to connect to the GitHub. | `string` | `""` | no |
| <a name="input_renovatebot_license"></a> [renovatebot\_license](#input\_renovatebot\_license) | The RenovateBot license key. | `string` | `""` | no |
| <a name="input_server_secret_key"></a> [server\_secret\_key](#input\_server\_secret\_key) | The secret key used to encrypt secrets in the server. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
