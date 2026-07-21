output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Final name assigned to the Key Vault (may include random suffix)"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "DNS URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "tenant_id" {
  description = "Tenant ID used by the Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}

output "auth_model" {
  description = "Authorization model in use"
  value       = var.enable_rbac_authorization ? "rbac" : "access-policy"
}