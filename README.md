## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup"></a> [backup](#module\_backup) | cloudposse/backup/aws | 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_region_settings.test](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/backup_region_settings) | resource |
| [aws_iam_policy.kms_access](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.backupper](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.allow_backup](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.allow_kms_access](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.aws_backup](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/resources/kms_key) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_access](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_resources"></a> [backup\_resources](#input\_backup\_resources) | Set of resources ARN to be backed up | `set(string)` | n/a | yes |
| <a name="input_cold_storage_after"></a> [cold\_storage\_after](#input\_cold\_storage\_after) | Specifies the number of days after creation that a recovery point is moved to cold storage | `number` | `null` | no |
| <a name="input_completion_window"></a> [completion\_window](#input\_completion\_window) | The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than start\_window. | `number` | `null` | no |
| <a name="input_delete_after"></a> [delete\_after](#input\_delete\_after) | Number of days before backup is deleted | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of backup resource | `string` | n/a | yes |
| <a name="input_resources_kms_key_arns"></a> [resources\_kms\_key\_arns](#input\_resources\_kms\_key\_arns) | Resource KMS key arns used to decrypt for backup | `set(string)` | `[]` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Backup schedule in cron expression | `string` | n/a | yes |
| <a name="input_start_window"></a> [start\_window](#input\_start\_window) | The amount of time in minutes before beginning a backup. Minimum value is 60 minutes | `number` | `null` | no |

## Outputs

No outputs.
