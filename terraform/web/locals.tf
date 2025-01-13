locals {
  global_local_tags = {
    costcenter = "12345"
  }
  web_subnet = one([
    for k, v in data.terraform_remote_state.network.outputs.mgmt_vnet_output.subnets :
    v if can(regex(".*web.*", lower(k)))
  ])

  vm_web_defaults = {
    resource_group_name  = data.terraform_remote_state.region-setup.outputs.region_setup_output.application_rg_name
    location             = var.default_config.location
    tags                 = merge(var.default_config.global_tags, local.global_local_tags)
    admin_username       = "ubuntu"
    admin_ssh_public_key = tls_private_key.ssh_web.public_key_openssh
    additional_ssh_keys  = []
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
    subnet_id            = local.web_subnet
    boot_diagnostics_uri = data.terraform_remote_state.region-setup.outputs.region_setup_output.vmdiag_endpoint
  }

  load_balancer_defaults = {
    resource_group_name = data.terraform_remote_state.region-setup.outputs.region_setup_output.application_rg_name
    location            = var.default_config.location
    tags                = merge(var.default_config.global_tags, local.global_local_tags)
    subnet_id           = local.web_subnet
  }
}