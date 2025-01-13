module "core" {
  source = "github.com/Coalfire-CF/terraform-azurerm-security-core"

  # Core Configuration
  subscription_id       = var.default_config.subscription_id
  tenant_id             = var.default_config.tenant_id
  resource_prefix       = "${var.default_config.app_abbreviation}-core"
  location              = var.default_config.location
  location_abbreviation = var.default_config.location_abbreviation
  app_abbreviation      = var.default_config.app_abbreviation

  # Resource Group
  core_rg_name = "${var.default_config.app_abbreviation}-core-rg"

  # Network Security
  cidrs_for_remote_access = var.default_config.cidrs_for_remote_access
  ip_for_remote_access    = var.default_config.ip_for_remote_access

  # Access Control
  admin_principal_ids = var.default_config.admin_principal_ids

  # DNS Configuration
  private_dns_zone_name = var.default_config.domain_name
  app_subscription_ids  = var.default_config.app_subscription_ids

  # Feature Flags
  enable_sub_logs        = false
  enable_aad_logs        = false
  enable_aad_permissions = false

  # Tags
  regional_tags = var.default_config.regional_tags
  global_tags   = var.default_config.global_tags

  # Private DNS Zones
  custom_private_dns_zones = [var.default_config.domain_name]
  azure_private_dns_zones  = var.default_config.security_core.azure_private_dns_zones
}
