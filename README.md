# Terraform Aws Backup Module
Terraform module to setup AWS Backup

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Example
```hcl
module "backup" {
  source                     = "blackbird-cloud/backup/aws"
  version                    = "~> 1"
  name                       = "centralized-backup"
  kms_key_arn                = "arn:aws:kms:us-west-2:xxxxx:key/xxxxxxxxxxxxx"
  create_backup_plan         = true
  create_backup_vault_policy = true
  resource_type_opt_in_preference = {
    "Aurora" : true,
    "EBS" : true,
    "EC2" : true,
    "RDS" : true,
    "S3" : true,
  }

  selection = {
    create_default_role = true
    condition = {
      string_equals = [{
        key   = "aws:ResourceTag/Backup"
        value = "true"
      }]
    }
    resources = ["*"]
  }

  rules = [
    {
      schedule          = "cron(0 3 * * ? *)" # Every day at 03:00 UTC
      start_window      = 60
      completion_window = 120
      lifecycle = {
        delete_after = 30
      }
    }
  ]

  vault_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Sid": "Allow access to backup vault",
        "Effect": "Allow",
        "Action": "backup:CopyIntoBackupVault",
        "Resource": "*",
        "Principal": "*",
        "Condition": {
          "StringEquals": {
            "aws:AccountId": "123456789012"
          }
        }
      }
  ]
}
EOF
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_region_settings.settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_selection.selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_role.backup_selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup_selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_backup_plan"></a> [create\_backup\_plan](#input\_create\_backup\_plan) | (Optional) Create an AWS Backup plan, requires the rules variable to be configured as well. | `bool` | `true` | no |
| <a name="input_create_backup_region_settings"></a> [create\_backup\_region\_settings](#input\_create\_backup\_region\_settings) | (Optional) Create an AWS Backup Region Settings resource. | `bool` | `true` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | (Optional) IAM role arn to use when making backups. | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Required) The server-side encryption key that is used to protect your backups. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of backup resource | `string` | n/a | yes |
| <a name="input_resource_type_management_preference"></a> [resource\_type\_management\_preference](#input\_resource\_type\_management\_preference) | (Optional) A map of services along with the management preferences for the Region. | `any` | <pre>{<br>  "DynamoDB": true,<br>  "EFS": true<br>}</pre> | no |
| <a name="input_resource_type_opt_in_preference"></a> [resource\_type\_opt\_in\_preference](#input\_resource\_type\_opt\_in\_preference) | (Optional) A map of services along with the opt-in preferences for the Region. | `any` | <pre>{<br>  "Aurora": true,<br>  "CloudFormation": true,<br>  "DocumentDB": true,<br>  "DynamoDB": true,<br>  "EBS": true,<br>  "EC2": true,<br>  "EFS": true,<br>  "FSx": true,<br>  "Neptune": true,<br>  "RDS": true,<br>  "Redshift": true,<br>  "S3": true,<br>  "Storage Gateway": true,<br>  "Timestream": true,<br>  "VirtualMachine": true<br>}</pre> | no |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional) An list of rules to create for the backup plan. | `list(any)` | `[]` | no |
| <a name="input_selection"></a> [selection](#input\_selection) | (Optional) Manages selection conditions for AWS Backup plan resources. | <pre>object({<br>    create_default_role : bool,<br>    resources : optional(list(string)),<br>    not_resources : optional(list(string)),<br>    condition : any<br>  })</pre> | <pre>{<br>  "condition": {},<br>  "create_default_role": false<br>}</pre> | no |
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

Copyright © 2017-2025 [Blackbird Cloud](https://blackbird.cloud)