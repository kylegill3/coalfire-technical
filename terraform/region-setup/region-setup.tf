module "setup" {
  source = "github.com/Coalfire-CF/terraform-azurerm-region-setup"

  location_abbreviation = var.default_config.location_abbreviation
  location              = var.default_config.location
  resource_prefix       = var.default_config.app_abbreviation
  app_abbreviation      = var.default_config.app_abbreviation
  regional_tags         = var.default_config.regional_tags
  global_tags           = merge(var.default_config.global_tags, local.global_local_tags)
  mgmt_rg_name          = "${var.default_config.app_abbreviation}-management-rg"
  app_rg_name           = "${var.default_config.app_abbreviation}-application-rg"
  key_vault_rg_name     = "${var.default_config.app_abbreviation}-keyvault-rg"
  networking_rg_name    = "${var.default_config.app_abbreviation}-networking-rg"
  sas_start_date        = "2025-01-09" #Change to today's date
  sas_end_date          = "2025-02-09" #Change to one month from now
  ip_for_remote_access  = var.default_config.ip_for_remote_access
  core_kv_id            = data.terraform_remote_state.security-core.outputs.core_output.core_kv_id
  diag_log_analytics_id = data.terraform_remote_state.security-core.outputs.core_output.core_la_id
}