data "terraform_remote_state" "region-setup" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "region-setup.tfstate"
  }
}

data "terraform_remote_state" "security-core" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "security-core.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "network.tfstate"
  }
}

data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "management.tfstate"
  }
}