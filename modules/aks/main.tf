resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.cluster_name}-dns"
  tags                = var.tags

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}