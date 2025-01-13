data "terraform_remote_state" "security-core" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cf-prod-core-rg"
    storage_account_name = "cfprodcoresatfstate"
    container_name       = "cuscf-prodtfstatecontainer"
    key                  = "security-core.tfstate"
  }
}