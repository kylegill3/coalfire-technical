module "web_subnet_nsg" {
  source = "github.com/Coalfire-CF/terraform-azurerm-nsg"

  location                          = var.default_config.location
  resource_group_name               = data.terraform_remote_state.region-setup.outputs.region_setup_output.network_rg_name
  security_group_name               = "ubu-web-subnet-nsg"
  storage_account_flowlogs_id       = data.terraform_remote_state.region-setup.outputs.region_setup_output.storage_account_flowlogs_id
  network_watcher_name              = data.terraform_remote_state.region-setup.outputs.region_setup_output.network_watcher_name
  network_watcher_flow_log_name     = "${data.terraform_remote_state.region-setup.outputs.region_setup_output.network_watcher_name}-websub"
  network_watcher_flow_log_location = var.default_config.location
  diag_log_analytics_id             = data.terraform_remote_state.security-core.outputs.core_output.core_la_id
  diag_log_analytics_workspace_id   = data.terraform_remote_state.security-core.outputs.core_output.core_la_workspace_id

  regional_tags = var.default_config.regional_tags
  global_tags   = var.default_config.global_tags

  custom_rules = [
    {
      name                    = "SSH"
      priority                = "100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "22"
      source_address_prefixes = [for vm in data.terraform_remote_state.management.outputs.mgmt_output.vm : vm.private_ip_address]
      description             = "SSH from mgmt VM"
    },
    {
      name                    = "HTTP"
      priority                = "101"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "80"
      source_address_prefixes = [module.web_lb.load_balancer_private_ip_address]
      description             = "HTTP from LB"
    },
    {
      name                    = "HTTPS"
      priority                = "102"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "443"
      source_address_prefixes = [module.web_lb.load_balancer_private_ip_address]
      description             = "HTTPS from LB"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "web_sub_nsg_association" {
  subnet_id                 = local.web_subnet
  network_security_group_id = module.web_subnet_nsg.network_security_group_id
}