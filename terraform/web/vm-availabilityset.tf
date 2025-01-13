provider "azurerm" {
  features {}
  subscription_id = var.default_config.subscription_id
  tenant_id       = var.default_config.tenant_id
}

module "avd_availability_set" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-AvailabilitySet?ref=v0.0.4"

  availability_set_name = "${var.default_config.app_abbreviation}-avd-as"
  location              = var.default_config.location
  resource_group_name   = data.terraform_remote_state.region-setup.outputs.region_setup_output.application_rg_name
  regional_tags         = var.default_config.regional_tags
  global_tags           = var.default_config.global_tags
}