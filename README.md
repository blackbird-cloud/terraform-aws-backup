# <Cloud> <Main resource> Terraform module
A Terraform module which configures your <Cloud> <Main resource>. <Relevant docs>
[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.48.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.plan](https://registry.terraform.io/providers/hashicorp/aws/4.48.0/docs/resources/backup_plan) | resource |
| [aws_backup_region_settings.settings](https://registry.terraform.io/providers/hashicorp/aws/4.48.0/docs/resources/backup_region_settings) | resource |
| [aws_backup_selection.selection](https://registry.terraform.io/providers/hashicorp/aws/4.48.0/docs/resources/backup_selection) | resource |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/4.48.0/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/4.48.0/docs/resources/backup_vault_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_backup_plan"></a> [create\_backup\_plan](#input\_create\_backup\_plan) | (Optional) Create an AWS Backup plan, requires the rules variable to be configured as well. | `bool` | `true` | no |
| <a name="input_create_backup_region_settings"></a> [create\_backup\_region\_settings](#input\_create\_backup\_region\_settings) | (Optional) Create an AWS Backup Region Settings resource. | `bool` | `true` | no |
| <a name="input_create_backup_vault_policy"></a> [create\_backup\_vault\_policy](#input\_create\_backup\_vault\_policy) | (Optional) Create an AWS Backup Policy | `bool` | `false` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | (Optional) IAM role arn to use when making backups. | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Required) The server-side encryption key that is used to protect your backups. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of backup resource | `string` | n/a | yes |
| <a name="input_resource_type_management_preference"></a> [resource\_type\_management\_preference](#input\_resource\_type\_management\_preference) | (Optional) A map of services along with the management preferences for the Region. | `any` | <pre>{<br>  "DynamoDB": true,<br>  "EFS": true<br>}</pre> | no |
| <a name="input_resource_type_opt_in_preference"></a> [resource\_type\_opt\_in\_preference](#input\_resource\_type\_opt\_in\_preference) | (Optional) A map of services along with the opt-in preferences for the Region. | `any` | <pre>{<br>  "Aurora": true,<br>  "CloudFormation": true,<br>  "DocumentDB": true,<br>  "DynamoDB": true,<br>  "EBS": true,<br>  "EC2": true,<br>  "EFS": true,<br>  "FSx": true,<br>  "Neptune": true,<br>  "RDS": true,<br>  "Redshift": true,<br>  "S3": true,<br>  "Storage Gateway": true,<br>  "Timestream": true,<br>  "VirtualMachine": true<br>}</pre> | no |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional) An list of rules to create for the backup plan. | `list(any)` | `[]` | no |
| <a name="input_selection"></a> [selection](#input\_selection) | (Optional) Manages selection conditions for AWS Backup plan resources. | <pre>object({<br>    resources : list(string),<br>    not_resources : list(string),<br>    condition : any<br>  })</pre> | <pre>{<br>  "condition": {},<br>  "not_resources": [],<br>  "resources": []<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Metadata that you can assign to help organize the resources that you create. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_vault_policy"></a> [vault\_policy](#input\_vault\_policy) | (Optional) The backup vault access policy document in JSON format. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault"></a> [vault](#output\_vault) | AWS Backup Vault |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)