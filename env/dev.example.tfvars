template_key        = "vm-linux"
subscription_id     = "00000000-0000-0000-0000-000000000000"
location            = "centralindia"
environment         = "dev"
resource_group_name = "rg-itops-dev-01"
resource_name       = "vm-itops-dev-01"
sku_or_size         = "Standard_D4as_v5"
owner               = "IT Ops"
cost_center         = "OPS-1001"

tags = {
  application = "provisioning-engine"
  owner       = "IT Ops"
  environment = "dev"
}