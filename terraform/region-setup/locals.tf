locals {
  #resource_prefix = "cfc-kg"
  global_local_tags = {
    costcenter = "12345"
  }
  region_setup_output = {
    network_rg_name             = module.setup.network_rg_name
    application_rg_name         = module.setup.application_rg_name
    management_rg_name          = module.setup.management_rg_name
    vmdiag_endpoint             = module.setup.vmdiag_endpoint
    storage_account_flowlogs_id = module.setup.storage_account_flowlogs_id
    network_watcher_name        = module.setup.network_watcher_name

  }
}