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
