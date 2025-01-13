provider "azurerm" {
  features {}
  subscription_id = var.default_config.subscription_id
  tenant_id       = var.default_config.tenant_id
}