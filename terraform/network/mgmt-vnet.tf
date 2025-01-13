module "mgmt-vnet" {
  source = "github.com/Coalfire-CF/ACE-Azure-Vnet?ref=module"

  vnet_name           = "${var.default_config.app_abbreviation}-network-vnet"
  resource_group_name = data.terraform_remote_state.region-setup.outputs.region_setup_output.network_rg_name
  address_space       = [module.subnet_addrs.base_cidr_block]
  subnets = {
    "${var.default_config.app_abbreviation}-application-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${var.default_config.app_abbreviation}-application-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${var.default_config.app_abbreviation}-management-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${var.default_config.app_abbreviation}-management-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${var.default_config.app_abbreviation}-backend-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${var.default_config.app_abbreviation}-backend-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
    }

    "${var.default_config.app_abbreviation}-web-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${var.default_config.app_abbreviation}-web-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
  }

  diag_log_analytics_id = data.terraform_remote_state.security-core.outputs.core_output.core_la_id

  #Attach Vnet to Private DNS zone
  private_dns_zone_id = data.terraform_remote_state.security-core.outputs.core_output.core_private_dns_zone_id.0

  #Note: DNS servers should be left to Azure default until the DC's are up. Otherwise the VM's will fail to get DNS to download scripts from storage accounts.
  #dns_servers   = concat(data.terraform_remote_state.usgv-ad.outputs.ad_dc1_ip, data.terraform_remote_state.usgv-ad.outputs.ad_dc2_ip)
  #regional_tags = var.default_config.regional_tags
  #global_tags   = merge(var.default_config.global_tags, local.global_local_tags)
  tags = {
    Function = "Networking"
    Plane    = "Management"
  }
}