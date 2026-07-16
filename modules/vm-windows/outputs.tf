output "vm_id" {
  description = "Resource ID of the Windows VM"
  value       = azurerm_windows_virtual_machine.this.id
}

output "vm_name" {
  description = "Name of the Windows VM"
  value       = azurerm_windows_virtual_machine.this.name
}

output "computer_name" {
  description = "Windows OS hostname"
  value       = azurerm_windows_virtual_machine.this.computer_name
}

output "private_ip_address" {
  description = "Primary private IP address"
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  description = "Public IP (null if disabled)"
  value       = var.enable_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

output "admin_username" {
  description = "Administrator username"
  value       = var.admin_username
}

output "admin_password" {
  description = "Administrator password (only returned if module generated it or you passed one)"
  value       = local.password
  sensitive   = true
}

output "principal_id" {
  description = "Principal ID of system-assigned identity (null if disabled)"
  value       = var.enable_system_assigned_identity ? azurerm_windows_virtual_machine.this.identity[0].principal_id : null
}