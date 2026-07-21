locals {
  common_tags = merge(var.tags, {
    owner       = var.owner
    cost_center = var.cost_center
    environment = var.environment
    managed_by  = "terraform"
    platform    = "provisioning-engine"
    request_id  = var.request_id
  })
}

module "resource_group" {
  source = "./modules/resource-group"
  count  = var.template_key == "resource-group" ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.common_tags
}

module "vm_linux" {
  source = "./modules/vm-linux"
  count  = var.template_key == "vm-linux" ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.resource_name
  vm_size             = var.sku_or_size
  admin_username      = "azureuser"
  tags                = local.common_tags
}

module "storage_account" {
  source = "./modules/storage-account"
  count  = var.template_key == "storage-account" ? 1 : 0

  resource_group_name      = var.resource_group_name
  location                 = var.location
  storage_account_name     = var.resource_name
  account_tier             = "Standard"
  account_replication_type = replace(var.sku_or_size, "Standard_", "")
  tags                     = local.common_tags
}

module "aks" {
  source = "./modules/aks"
  count  = var.template_key == "aks" ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.resource_name
  node_vm_size        = var.sku_or_size
  tags                = local.common_tags
}

module "vm_windows" {
  source = "./modules/vm-windows"
  count  = var.template_key == "vm-windows" ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.resource_name
  vm_size             = var.sku_or_size
  admin_username      = "azureadmin"
  tags                = local.common_tags
}

module "key_vault" {
  source = "./modules/key-vault"
  count  = var.template_key == "key-vault" ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_name      = var.resource_name
  sku_name            = var.sku_or_size == "premium" ? "premium" : "standard"
  tags                = local.common_tags
  additional_access_policies = [{
    object_id               = "bd96d116-55e5-4183-9cb1-63eb5496f4a1"
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }]
}

locals {
  resource_id = (
    var.template_key == "resource-group"  ? module.resource_group[0].resource_group_id  :
    var.template_key == "vm-linux"        ? module.vm_linux[0].vm_id                    :
    var.template_key == "vm-windows"      ? module.vm_windows[0].vm_id                  :
    var.template_key == "storage-account" ? module.storage_account[0].storage_account_id :
    var.template_key == "key-vault"       ? module.key_vault[0].key_vault_id            :
    module.aks[0].aks_id
  )
}

