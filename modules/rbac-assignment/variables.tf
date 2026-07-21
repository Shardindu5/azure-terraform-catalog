variable "scope" {
  description = "Azure resource ID scope for the role assignment"
  type        = string
}

variable "role_definition_name" {
  description = "Human-readable role name (e.g. 'Reader', 'Contributor', 'Key Vault Secrets User')"
  type        = string
}

variable "principal_id" {
  description = "Object ID of the user, group, or service principal to grant"
  type        = string
}

variable "principal_type" {
  description = "One of: User, Group, ServicePrincipal, ForeignGroup, Device"
  type        = string
  default     = "User"
  validation {
    condition     = contains(["User", "Group", "ServicePrincipal", "ForeignGroup", "Device"], var.principal_type)
    error_message = "principal_type must be User, Group, ServicePrincipal, ForeignGroup, or Device."
  }
}

variable "description" {
  description = "Human-readable description of why this assignment exists"
  type        = string
  default     = ""
}

variable "condition" {
  description = "Optional ABAC condition string"
  type        = string
  default     = ""
}

variable "condition_version" {
  description = "Optional ABAC condition version (usually '2.0')"
  type        = string
  default     = ""
}