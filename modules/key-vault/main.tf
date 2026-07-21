data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  count   = var.append_random_suffix ? 1 : 0
  length  = 4
  upper   = false
  special = false
  numeric = true
}

locals {
  # Trim requested name so name + suffix stays within 24 chars
  suffix        = var.append_random_suffix ? "-${random_string.suffix[0].result}" : ""
  base_max_len  = 24 - length(local.suffix)
  base_name     = substr(var.key_vault_name, 0, local.base_max_len)
  full_kv_name  = "${local.base_name}${local.suffix}"

  # Full access permissions for admin access policy
  admin_secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  admin_key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup",
    "Restore", "Purge", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign"
  ]
  admin_certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup",
    "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers",
    "SetIssuers", "DeleteIssuers", "Purge"
  ]
  admin_storage_permissions = [
    "Get", "List", "Update", "Set", "Delete", "Recover", "Backup", "Restore",
    "Purge", "RegenerateKey", "SetSAS", "ListSAS", "GetSAS", "DeleteSAS"
  ]
}

resource "azurerm_key_vault" "this" {
  name                = local.full_kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = var.sku_name

  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  public_network_access_enabled   = var.public_network_access_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  network_acls {
    default_action = var.public_network_access_enabled ? var.network_default_action : "Deny"
    bypass         = var.network_bypass
    ip_rules       = var.allowed_ip_ranges
  }

  # Admin access policy for the workflow SP (only when using access policies)
  dynamic "access_policy" {
    for_each = (!var.enable_rbac_authorization && var.grant_admin_to_current_user) ? [1] : []
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      secret_permissions      = local.admin_secret_permissions
      key_permissions         = local.admin_key_permissions
      certificate_permissions = local.admin_certificate_permissions
      storage_permissions     = local.admin_storage_permissions
    }
  }

  # Any additional access policies passed in by the caller
  dynamic "access_policy" {
    for_each = var.enable_rbac_authorization ? [] : var.additional_access_policies
    content {
      tenant_id               = coalesce(access_policy.value.tenant_id, data.azurerm_client_config.current.tenant_id)
      object_id               = access_policy.value.object_id
      secret_permissions      = access_policy.value.secret_permissions
      key_permissions         = access_policy.value.key_permissions
      certificate_permissions = access_policy.value.certificate_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }

  tags = merge(var.tags, {
    resource_type = "key-vault"
    sku           = var.sku_name
    auth_model    = var.enable_rbac_authorization ? "rbac" : "access-policy"
  })
}
