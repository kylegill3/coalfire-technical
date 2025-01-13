terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.116.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "security-core.tfstate"
  }
}
