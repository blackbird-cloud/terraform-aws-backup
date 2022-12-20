variable "name" {
  type        = string
  description = "Name of backup resource"
}

variable "backup_resources" {
  type        = set(string)
  description = "Set of resources ARN to be backed up"
}

variable "schedule" {
  type        = string
  description = "Backup schedule in cron expression"
}

variable "start_window" {
  type        = number
  description = "The amount of time in minutes before beginning a backup. Minimum value is 60 minutes"
  default     = null
}

variable "completion_window" {
  type        = number
  description = "The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than start_window."
  default     = null
}

variable "cold_storage_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
  default     = null
}

variable "delete_after" {
  type        = number
  description = "Number of days before backup is deleted"
  default     = null
}

variable "resources_kms_key_arns" {
  type        = set(string)
  description = "Resource KMS key arns used to decrypt for backup"
  default     = []
}

variable "copy_destination_vault_arn" {
  description = "An Amazon Resource Name (ARN) that uniquely identifies the destination backup vault for the copied backup"
  type        = string
  default     = null
}
