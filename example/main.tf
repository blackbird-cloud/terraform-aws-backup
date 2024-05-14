module "backup" {
  source                              = "../"
  name                                = "centralized-backup"
  kms_key_arn                         = "arn:aws:kms:us-west-2:xxxxx:key/xxxxxxxxxxxxx"
}
