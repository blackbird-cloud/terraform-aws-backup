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
  iam_role_arn  = var.iam_role_arn != "" ? var.iam_role_arn : (var.selection.create_default_role == true || var.iam_role_arn == "" ? aws_iam_role.backup_selection[0].arn : "")
  plan_id       = aws_backup_plan.plan[0].id
  resources     = try(var.selection.resources, [])
  not_resources = try(var.selection.not_resources, [])
  dynamic "condition" {
    for_each = try(var.selection.condition, null) == null ? [] : [true]

    content {
      dynamic "string_equals" {
        for_each = try(var.selection.condition.string_equals, [])
        content {
          key   = string_equals.key
          value = string_equals.value
        }
      }
      dynamic "string_like" {
        for_each = try(var.selection.condition.string_like, [])
        content {
          key   = string_like.key
          value = string_like.value
        }
      }
      dynamic "string_not_equals" {
        for_each = try(var.selection.condition.string_not_equals, [])
        content {
          key   = string_not_equals.key
          value = string_not_equals.value
        }
      }
      dynamic "string_not_like" {
        for_each = try(var.selection.condition.string_not_like, [])
        content {
          key   = string_not_like.key
          value = string_not_like.value
        }
      }
    }
  }
}

resource "aws_backup_vault_policy" "policy" {
  count = var.create_backup_plan ? 1 : 0

  backup_vault_name = aws_backup_vault.vault.name
  policy            = var.vault_policy
}

# default role for aws_backup_selection if not provided
data "aws_iam_policy_document" "assume_role" {
  count = var.create_backup_plan && (var.selection.create_default_role == true || var.iam_role_arn == "") ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "backup_selection" {
  count              = var.create_backup_plan && (var.selection.create_default_role == true || var.iam_role_arn == "") ? 1 : 0
  name               = "backup_selection"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "backup_selection" {
  count      = var.create_backup_plan && (var.selection.create_default_role == true || var.iam_role_arn == "") ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_selection[0].name
}
