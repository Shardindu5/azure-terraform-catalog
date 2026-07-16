variable "resource_group_name" {
  description = "Name of the resource group (must already exist)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "key_vault_name" {
  description = "Requested Key Vault name. Must be globally unique. 3-24 chars, alphanumeric and hyphens."
  type        = string
  validation {
    condition     = length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 24
    error_message = "key_vault_name must be between 3 and 24 characters."
  }
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "key_vault_name must start with a letter, end with letter/digit, and contain only letters, digits, and hyphens."
  }
}

variable "append_random_suffix" {
  description = "Append a 4-char random suffix to ensure global uniqueness"
  type        = bool
  default     = true
}

variable "sku_name" {
  description = "SKU: standard or premium"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be 'standard' or 'premium'."
  }
}

variable "enable_rbac_authorization" {
  description = "Use Azure RBAC for data-plane access (recommended). If false, uses legacy access policies."
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Enable purge protection (cannot be undone). Recommended: true for stage/prod."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days deleted vault items are retained (7-90)"
  type        = number
  default     = 30
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed. Recommend false for prod."
  type        = bool
  default     = true
}

variable "network_default_action" {
  description = "Default network action when public access is enabled: Allow or Deny"
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.network_default_action)
    error_message = "network_default_action must be 'Allow' or 'Deny'."
  }
}

variable "network_bypass" {
  description = "Whether Azure services can bypass network rules"
  type        = string
  default     = "AzureServices"
  validation {
    condition     = contains(["None", "AzureServices"], var.network_bypass)
    error_message = "network_bypass must be 'None' or 'AzureServices'."
  }
}

variable "allowed_ip_ranges" {
  description = "List of public IP CIDR ranges to allow"
  type        = list(string)
  default     = []
}

variable "enabled_for_deployment" {
  description = "Allow Azure VMs to retrieve certs stored here"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Allow Azure Disk Encryption to retrieve secrets and unwrap keys"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Allow ARM templates to retrieve secrets"
  type        = bool
  default     = false
}

variable "grant_admin_to_current_user" {
  description = "Assign the caller (workflow SP / user) 'Key Vault Administrator' role so they can immediately manage secrets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}