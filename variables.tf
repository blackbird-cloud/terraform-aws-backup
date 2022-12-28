variable "name" {
  type        = string
  description = "(Required) Name of backup resource"
}

variable "create_backup_region_settings" {
  type        = bool
  default     = true
  description = "(Optional) Create an AWS Backup Region Settings resource."
}

variable "create_backup_plan" {
  type        = bool
  default     = true
  description = "(Optional) Create an AWS Backup plan, requires the rules variable to be configured as well."
}

variable "create_backup_vault_policy" {
  type        = bool
  default     = false
  description = "(Optional) Create an AWS Backup Policy"
}

variable "resource_type_opt_in_preference" {
  default = {
    "Aurora"          = true
    "DocumentDB"      = true
    "DynamoDB"        = true
    "EBS"             = true
    "EC2"             = true
    "EFS"             = true
    "FSx"             = true
    "Neptune"         = true
    "RDS"             = true
    "Storage Gateway" = true
    "VirtualMachine"  = true
    "CloudFormation"  = true
    "Redshift"        = true
    "Timestream"      = true
    "S3"              = true
  }
  type        = any
  description = "(Optional) A map of services along with the opt-in preferences for the Region."
}

variable "resource_type_management_preference" {
  type        = any
  description = "(Optional) A map of services along with the management preferences for the Region."
  default = {
    "DynamoDB" = true
    "EFS"      = true
  }
}

variable "selection" {
  type = object({
    resources : list(string),
    not_resources : list(string),
    condition : any
  })
  default = {
    not_resources = []
    resources     = []
    condition     = {}
  }
  description = "(Optional) Manages selection conditions for AWS Backup plan resources."
}

variable "kms_key_arn" {
  type        = string
  description = "(Required) The server-side encryption key that is used to protect your backups."
}

variable "tags" {
  description = "(Optional) Metadata that you can assign to help organize the resources that you create. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "rules" {
  type        = list(any)
  description = "(Optional) An list of rules to create for the backup plan."
  default     = []
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "(Optional) IAM role arn to use when making backups."
}

variable "vault_policy" {
  type        = string
  default     = null
  description = "(Optional) The backup vault access policy document in JSON format."
}
