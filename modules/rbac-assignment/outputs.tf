output "role_assignment_id" {
  value = azurerm_role_assignment.this.id
}

output "role_assignment_name" {
  value = azurerm_role_assignment.this.name
}

output "scope" {
  value = var.scope
}

output "role" {
  value = var.role_definition_name
}

output "principal_id" {
  value = var.principal_id
}