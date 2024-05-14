module "backup" {
  source      = "blackbird-cloud/backup/aws"
  version     = "~> 1"
  name        = "centralized-backup"
  kms_key_arn = "arn:aws:kms:us-west-2:xxxxx:key/xxxxxxxxxxxxx"
}
