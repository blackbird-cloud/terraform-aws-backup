resource "aws_backup_region_settings" "settings" {
  count = var.create_backup_region_settings ? 1 : 0

  resource_type_opt_in_preference     = var.resource_type_opt_in_preference
  resource_type_management_preference = var.resource_type_management_preference
}

resource "aws_backup_vault" "vault" {
  name        = var.name
  kms_key_arn = var.kms_key_arn
  tags        = var.tags
}

resource "aws_backup_plan" "plan" {
  count = var.create_backup_plan && length(var.rules) > 0 ? 1 : 0

  name = var.name

  dynamic "rule" {
    for_each = var.rules

    content {
      completion_window        = lookup(rule.value, "completion_window", null)
      enable_continuous_backup = lookup(rule.value, "enable_continuous_backup", null)
      recovery_point_tags      = var.tags
      rule_name                = lookup(rule.value, "name", "rule-${rule.key}")
      schedule                 = lookup(rule.value, "schedule", null)
      start_window             = lookup(rule.value, "start_window", null)
      target_vault_name        = aws_backup_vault.vault.name

      dynamic "lifecycle" {
        for_each = lookup(rule.value, "lifecycle", null) != null ? [true] : []

        content {
          cold_storage_after = lookup(rule.value.lifecycle, "cold_storage_after", null)
          delete_after       = lookup(rule.value.lifecycle, "delete_after", null)
        }
      }

      dynamic "copy_action" {
        for_each = lookup(rule.value, "copy_actions", [])

        content {
          destination_vault_arn = lookup(copy_action.value, "destination_vault_arn", null)

          dynamic "lifecycle" {
            for_each = lookup(copy_action.value, "lifecycle", null) != null ? [true] : []

            content {
              cold_storage_after = lookup(copy_action.value.lifecycle, "cold_storage_after", null)
              delete_after       = lookup(copy_action.value.lifecycle, "delete_after", null)
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_backup_selection" "selection" {
  count = var.create_backup_plan ? 1 : 0

  name          = var.name
  iam_role_arn  = var.iam_role_arn
  plan_id       = aws_backup_plan.plan[0].id
  resources     = try(var.selection.resources, [])
  not_resources = try(var.selection.not_resources, [])
  dynamic "selection_tag" {
    for_each = try(var.selection.selection_tags, [])
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}

resource "aws_backup_vault_policy" "policy" {
  count = var.create_backup_vault_policy ? 1 : 0

  backup_vault_name = aws_backup_vault.vault.name
  policy            = var.vault_policy
}
