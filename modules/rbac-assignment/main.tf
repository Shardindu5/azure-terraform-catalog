data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "this" {
  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
  principal_type       = var.principal_type
  description          = var.description

  condition         = var.condition != "" ? var.condition : null
  condition_version = var.condition != "" ? (var.condition_version != "" ? var.condition_version : "2.0") : null
}