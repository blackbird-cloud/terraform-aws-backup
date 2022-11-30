resource "aws_kms_key" "aws_backup" {
  description         = "${var.name} AWS Backup KMS key"
  enable_key_rotation = true
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kms_access" {
  statement {
    sid    = "AllowKMSKey"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateDataKeyPair",
      "kms:GenerateDataKeyPairWithoutPlaintext",
      "kms:DescribeKey"
    ]
    resources = var.resources_kms_key_arns
  }
}

resource "aws_iam_policy" "kms_access" {
  policy = data.aws_iam_policy_document.kms_access.json
  name   = var.name
}

resource "aws_iam_role" "backupper" {
  name               = var.name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
}

resource "aws_iam_role_policy_attachment" "allow_kms_access" {
  policy_arn = aws_iam_policy.kms_access.arn
  role       = aws_iam_role.backupper.name
}

resource "aws_iam_role_policy_attachment" "allow_backup" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backupper.name
}

resource "aws_backup_region_settings" "test" {
  resource_type_opt_in_preference = {
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
  }

  resource_type_management_preference = {
    "DynamoDB" = true
    "EFS"      = true
  }
}

module "backup" {
  source             = "cloudposse/backup/aws"
  version            = "0.12.0"
  name               = var.name
  backup_resources   = var.backup_resources
  schedule           = var.schedule
  start_window       = var.start_window
  completion_window  = var.completion_window
  cold_storage_after = var.cold_storage_after
  delete_after       = var.delete_after
  kms_key_arn        = aws_kms_key.aws_backup.arn
  iam_role_enabled   = false
  iam_role_name      = aws_iam_role.backupper.name
  depends_on = [
    aws_iam_role.backupper
  ]
}
