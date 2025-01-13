terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "region-setup.tfstate"
  }
}
