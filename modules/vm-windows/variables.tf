variable "resource_group_name" {
  description = "Name of the resource group where the VM will be created (must already exist)"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "vm_name" {
  description = "Name of the Windows VM (max 15 chars for Windows hostname compliance)"
  type        = string
  validation {
    condition     = length(var.vm_name) <= 15
    error_message = "Windows VM name must be 15 characters or fewer."
  }
}

variable "vm_size" {
  description = "Azure VM size / SKU"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "admin_username" {
  description = "Administrator username for the Windows VM"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Administrator password. If empty, a strong random password is generated."
  type        = string
  default     = ""
  sensitive   = true
}

variable "vnet_address_space" {
  description = "Address space for the auto-created VNet"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the auto-created subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "os_disk_type" {
  description = "OS disk storage type"
  type        = string
  default     = "StandardSSD_LRS"
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_type)
    error_message = "os_disk_type must be one of Standard_LRS, StandardSSD_LRS, Premium_LRS."
  }
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "windows_image" {
  description = "Windows image publisher/offer/sku/version"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

variable "enable_public_ip" {
  description = "Whether to create and attach a public IP"
  type        = bool
  default     = false
}

variable "enable_rdp_nsg_rule" {
  description = "Whether to allow inbound RDP (3389). Only allow when necessary."
  type        = bool
  default     = false
}

variable "allowed_rdp_source" {
  description = "Source CIDR/IP allowed to RDP. Ignored if enable_rdp_nsg_rule=false."
  type        = string
  default     = "*"
}

variable "enable_boot_diagnostics" {
  description = "Enable boot diagnostics with managed storage"
  type        = bool
  default     = true
}

variable "enable_system_assigned_identity" {
  description = "Enable a system-assigned managed identity on the VM"
  type        = bool
  default     = true
}

variable "timezone" {
  description = "Windows time zone"
  type        = string
  default     = "India Standard Time"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}