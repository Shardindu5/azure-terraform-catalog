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
}

resource "azurerm_key_vault" "this" {
  name                = local.base_name
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

  tags = merge(var.tags, {
    resource_type = "key-vault"
    sku           = var.sku_name
  })
}

# Give the caller admin access so they can immediately create/read secrets
# (only meaningful when RBAC authorization is enabled)
resource "azurerm_role_assignment" "current_user_admin" {
  count                = var.enable_rbac_authorization && var.grant_admin_to_current_user ? 1 : 0
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}