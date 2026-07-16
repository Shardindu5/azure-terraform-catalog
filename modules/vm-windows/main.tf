locals {
  vm_name_clean = lower(replace(var.vm_name, "_", "-"))
  password      = var.admin_password != "" ? var.admin_password : random_password.admin[0].result
}

# --- Random password fallback ---
resource "random_password" "admin" {
  count            = var.admin_password == "" ? 1 : 0
  length           = 20
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!@#$%^&*()-_=+"
}

# --- Networking ---
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.vm_name_clean}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = "snet-${local.vm_name_clean}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${local.vm_name_clean}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "rdp" {
  count                       = var.enable_rdp_nsg_rule ? 1 : 0
  name                        = "allow-rdp"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.allowed_rdp_source
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "pip-${local.vm_name_clean}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${local.vm_name_clean}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipcfg-primary"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.this[0].id : null
  }
}

# --- Windows Virtual Machine ---
resource "azurerm_windows_virtual_machine" "this" {
  name                = var.vm_name
  computer_name       = local.vm_name_clean
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = local.password
  network_interface_ids = [azurerm_network_interface.this.id]
  timezone              = var.timezone
  provision_vm_agent    = true
  enable_automatic_updates = true

  os_disk {
    name                 = "osdisk-${local.vm_name_clean}"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.windows_image.publisher
    offer     = var.windows_image.offer
    sku       = var.windows_image.sku
    version   = var.windows_image.version
  }

  dynamic "identity" {
    for_each = var.enable_system_assigned_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = null # managed storage
    }
  }

  tags = merge(var.tags, {
    os_type = "Windows"
    sku     = var.vm_size
  })
}