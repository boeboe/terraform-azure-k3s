# terraform-azure-k3s

![Terraform Version](https://img.shields.io/badge/terraform-≥_1.0.0-blueviolet)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/xunleii/terraform-module-k3s?label=registry)](https://registry.terraform.io/modules/boeboe/terraform-azure-k3s)
[![GitHub issues](https://img.shields.io/github/issues/xunleii/terraform-module-k3s)](https://github.com/boeboe/terraform-azure-k3s/issues)
[![Open Source Helpers](https://www.codetriage.com/xunleii/terraform-module-k3s/badges/users.svg)](https://www.codetriage.com/boeboe/terraform-module-k3s)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Terraform module which creates a [k3s](https://k3s.io/) cluster, with multi-server 
and annotations/labels/taints management features, on azure cloud. 

## Usage

``` hcl-terraform
module "terraform-azure-k3s" {
  source  = "boeboe/terraform-azure-k3s/module"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| k3s_version | k3s version to be use | string | `"latest"` | false |
| name | k3s cluster name | string | `"cluster.local"` | false |

## Outputs
| Name | Description | Type |
|------|-------------|------|
| summary | A summary of the current cluster state (version, server and agent list with all annotations, labels, ...) | string |
| kube_config | A yaml encoded kubeconfig file | string |
| kubernetes | A kubernetes object with cluster_ca_certificate, client_certificate and client_key properties | object |

## More information

TBC

## License

terraform-module-k3s is released under the **MIT License**. See the bundled [LICENSE](LICENSE) file for details.