module "rbac_assignment" {
  source = "../modules/rbac-assignment"

  scope                = var.scope
  role_definition_name = var.role
  principal_id         = var.principal_id
  principal_type       = var.principal_type
  description          = "${var.request_id} • ${var.environment} • Requested via Provisioning Engine"
}

output "role_assignment_id" {
  value = module.rbac_assignment.role_assignment_id
}